import Foundation

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

class AuthViewModel: ObservableObject {
    @Published var emailID: String = ""
    @Published var password: String = ""
    @Published var isLoggedInAdmin: Bool = false
    @Published var isLoggedInUser: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: ErrorMessage? = nil
    @Published var userRole: String? = nil
    @Published var isPasswordVisible: Bool = false
    @Published var token: String? = nil
    @Published var userAvatar: String? = nil

    func loginUser() {
        guard !emailID.isEmpty, !password.isEmpty else {
            errorMessage = ErrorMessage(message: "Please enter your email and password.")
            return
        }
        
        guard let url = URL(string: "\(Constants.baseURL)/login") else {
            errorMessage = ErrorMessage(message: "Invalid URL")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["email": emailID, "password": password]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            errorMessage = ErrorMessage(message: "Failed to encode parameters")
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Request error: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Invalid response from server.")
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    self.token = responseJson?["token"] as? String
                    UserDefaults.standard.set(self.token, forKey: "userToken")
                    
                    self.decodeToken()
                    self.fetchUserAvatar()
                    
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = ErrorMessage(message: "Failed to parse response.")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Login failed with status code: \(httpResponse.statusCode). Please check your credentials and try again.")
                }
            }
        }.resume()
    }
    
    func decodeToken() {
        guard let token = token else { return }
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return }
        
        let payload = segments[1]
        let base64Payload = String(payload)
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padding = 4 - (base64Payload.count % 4)
        let paddedBase64Payload = base64Payload + String(repeating: "=", count: padding % 4)
        
        guard let decodedData = Data(base64Encoded: paddedBase64Payload) else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any] {
                if let role = json["role"] as? String {
                    DispatchQueue.main.async {
                        self.userRole = role
                        if role == "admin" {
                            self.isLoggedInAdmin = true
                        } else {
                            self.isLoggedInUser = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = ErrorMessage(message: "Role not found.")
                        self.isLoggedInAdmin = false
                        self.isLoggedInUser = false
                    }
                }
            }
        } catch {
            print("Failed to decode JWT: \(error.localizedDescription)")
        }
    }

    func fetchUserAvatar() {
        guard let token = token else { return }
        guard let userId = decodeUserIdFromToken() else { return }
        guard let url = URL(string: "\(Constants.usersEndpoint)/\(userId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to fetch avatar: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let userJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let avatar = userJson["avatar"] as? String {
                    DispatchQueue.main.async {
                        self.userAvatar = avatar
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = ErrorMessage(message: "Avatar not found in user data.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to decode user data.")
                }
            }
        }.resume()
    }

    func decodeUserIdFromToken() -> String? {
        guard let token = token else { return nil }
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return nil }

        let payload = segments[1]
        let base64Payload = String(payload)
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let padding = 4 - (base64Payload.count % 4)
        let paddedBase64Payload = base64Payload + String(repeating: "=", count: padding % 4)

        guard let decodedData = Data(base64Encoded: paddedBase64Payload) else { return nil }

        do {
            if let json = try JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any],
               let userId = json["id"] as? String {
                return userId
            }
        } catch {
            print("Failed to decode JWT: \(error.localizedDescription)")
        }
        
        return nil
    }
}
