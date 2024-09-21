import SwiftUI

struct RegisterView: View {
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isRegistered: Bool = false
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .center, spacing: 10) {
                Image("Page 3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 20)

                Text("Create Your Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Please fill in the form to register a new account.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)

            CustomTextField(text: $emailID, hint: "Email Address", leadingIcon: Image(systemName: "envelope"))

            SecureField("Password", text: $password)
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1)))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gray, lineWidth: 1)
                )

            SecureField("Confirm Password", text: $confirmPassword)
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1)))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gray, lineWidth: 1)
                )

            Spacer(minLength: 10)

            if isLoading {
                ProgressView()
                    .padding(.vertical, 15)
            } else {
                Button(action: {
                    registerUser()
                }) {
                    Text("Register")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.black))
                }
            }

            Button(action: { isRegistered = false }) {
                Text("Back to Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.top, 10)

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Register")
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Registration"),
                message: Text(errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func registerUser() {
        guard !emailID.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "Please check all fields"
            showAlert = true
            return
        }
        
        guard let url = URL(string: "\(Constants.baseURL)/register") else {
            errorMessage = "Invalid URL"
            showAlert = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = [
            "email": emailID,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            errorMessage = "Failed to encode parameters"
            isLoading = false
            showAlert = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Request error: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    showAlert = true
                }
            } else {
                DispatchQueue.main.async {
                   
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
