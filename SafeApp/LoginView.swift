import SwiftUI

struct LoginView: View {
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showAlert: Bool = false
    @State private var token: String? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                VStack(alignment: .center, spacing: 10) {
                    Image("Page 3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 20)

                    Text("Let's Get Started")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("To register for an account, kindly enter your details.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.bottom, 30)

                CustomTextField(text: $emailID, hint: "Email Address", leadingIcon: Image(systemName: "envelope"))

                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .font(.callout)

                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1)))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gray, lineWidth: 1)
                )

                Spacer(minLength: 10)

                NavigationLink(destination: HomeScreen(token: token), isActive: $isLoggedIn) {
                    EmptyView()
                }

                if isLoading {
                    ProgressView()
                        .padding(.vertical, 15)
                } else {
                    Button(action: {
                        loginUser()
                    }) {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Capsule().fill(Color.black))
                    }
                }

                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)

            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Login")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login"),
                    message: Text(errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    func loginUser() {
        guard !emailID.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            showAlert = true
            return
        }
        
        guard let url = URL(string: "\(Constants.baseURL)/login") else {
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
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        self.token = responseJson?["token"] as? String
                        DispatchQueue.main.async {
                            isLoggedIn = true
                        }
                    } catch {
                        DispatchQueue.main.async {
                            errorMessage = "Failed to parse response"
                            showAlert = true
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Login failed. Please check your credentials and try again."
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
