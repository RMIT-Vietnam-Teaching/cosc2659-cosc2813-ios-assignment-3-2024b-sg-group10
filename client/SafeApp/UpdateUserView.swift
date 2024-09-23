/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Team 10
  ID: s3978826, s3978481, s388418, s3979367
  Created  date: 3/9/2024
  Last modified: 23/9/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/
import SwiftUI

struct UpdateUserView: View {
    var token: String
    @State private var userInfo: [String: Any]? = nil
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    
    @State private var email: String = ""
    @State private var role: String = ""
    @State private var avatar: String = ""
    
    @State private var showDefaultAvatar: Bool = false

    var body: some View {
        VStack {
            if let userInfo = userInfo {
                ZStack {
                    if showDefaultAvatar || avatar.isEmpty || URL(string: avatar) == nil {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding()
                    } else {
                        AsyncImage(url: URL(string: avatar)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .padding()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.showDefaultAvatar = true
                    }
                }

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear {
                        self.email = userInfo["email"] as? String ?? ""
                        self.role = userInfo["role"] as? String ?? ""
                        self.avatar = userInfo["avatar"] as? String ?? ""
                    }

                TextField("Role", text: $role)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    updateUser()
                }) {
                    Text("Update")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top)
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .padding()
                    .foregroundColor(.red)
            } else {
                Text("Loading user info...")
                    .padding()
            }
        }
        .onAppear {
            fetchUserInfo()
        }
        .navigationTitle("User Info")
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

struct UpdateUserView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmVlNzMxMjJmZDIyOTllZWNkNzE5MmYiLCJyb2xlIjoidXNlciIsImlhdCI6MTcyNjk5NTkwOSwiZXhwIjoxNzI3MDgyMzA5fQ.0KenY0L7_BY270cfqCbRgV-hEdUmNGdhoPFxIotz-ek")
    }
}
