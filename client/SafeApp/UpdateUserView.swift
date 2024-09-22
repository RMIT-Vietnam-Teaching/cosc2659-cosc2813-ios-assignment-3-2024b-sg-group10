import SwiftUI

struct UpdateUserView: View {
    var token: String
    @State private var userInfo: [String: Any]? = nil
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    
    @State private var email: String = ""
    @State private var role: String = ""
    @State private var avatar: String = ""

    var body: some View {
        ZStack {
            // Background gradient for the entire view
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                if let userInfo = userInfo {
                    // User info with custom styling
                    UserInfoView(label: "User ID", value: userInfo["userId"] as? String ?? "N/A")
                    
                    // Email input field
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onAppear {
                            self.email = userInfo["email"] as? String ?? ""
                            self.role = userInfo["role"] as? String ?? ""
                            self.avatar = userInfo["avatar"] as? String ?? ""
                        }
                    
                    // Role input field
                    TextField("Role", text: $role)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Avatar input field
                    TextField("Avatar URL", text: $avatar)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Update Button with improved design
                    Button(action: {
                        updateUser()
                    }) {
                        Text("Update Information")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 4)
                    }
                    .padding(.top, 16)
                    
                } else if let errorMessage = errorMessage {
                    // Error message display
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                        .padding()
                } else {
                    // Loading state
                    ProgressView("Loading user info...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 6)
            )
            .padding()
        }
        .onAppear {
            fetchUserInfo()
        }
        .navigationTitle("User Info")
        .navigationBarTitleDisplayMode(.inline)
    }

    func fetchUserInfo() {
        guard let userId = decode(jwtToken: token)?["userId"] as? String else {
            errorMessage = "Invalid token"
            return
        }

        let url = URL(string: "http://localhost:5001/api/users/\(userId)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        self.userInfo = json
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode JSON"
                }
            }
        }.resume()
    }

    func updateUser() {
        guard let userId = userInfo?["userId"] as? String else {
            errorMessage = "User ID not found"
            return
        }

        let updatedUserInfo: [String: Any] = [
            "email": email,
            "role": role,
            "avatar": avatar
        ]

        let url = URL(string: "http://localhost:5001/api/users/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let jsonData = try? JSONSerialization.data(withJSONObject: updatedUserInfo, options: []) else {
            errorMessage = "Error converting to JSON"
            return
        }

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        self.userInfo = json
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode JSON after update"
                }
            }
        }.resume()
    }

    func decode(jwtToken jwt: String) -> [String: Any]? {
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else { return nil }
        let base64String = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let requiredLength = (4 * ceil(Double(base64String.count) / 4.0))
        let paddingLength = requiredLength - Double(base64String.count)
        let paddedBase64String = base64String.padding(toLength: base64String.count + Int(paddingLength), withPad: "=", startingAt: 0)

        guard let decodedData = Data(base64Encoded: paddedBase64String),
              let json = try? JSONSerialization.jsonObject(with: decodedData, options: []),
              let payload = json as? [String: Any] else { return nil }

        return payload
    }
}

struct UserInfoView: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .foregroundColor(.blue)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.vertical, 6)
    }
}

struct UpdateUserView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserView(token: "your_jwt_token_here")
    }
}
