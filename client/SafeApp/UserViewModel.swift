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
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    var cancellables = Set<AnyCancellable>()
    var token: String
    
    init(token: String) {
        self.token = token
        fetchAllUsers()
    }
    
    func fetchAllUsers() {
        isLoading = true
        guard let url = URL(string: Constants.usersEndpoint) else {
            self.error = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = "Error fetching users: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }

    func fetchUserById(userId: String) {
        isLoading = true
        guard let url = URL(string: "\(Constants.usersEndpoint)/\(userId)") else {
            self.error = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = "Error fetching user: \(error.localizedDescription)"
                }
            }, receiveValue: { user in
                print("Fetched user: \(user)")
            })
            .store(in: &cancellables)
    }
    
    func deleteUser(_ user: User) {
        guard let userId = user.id, !userId.isEmpty else {
            self.error = "Invalid user ID"
            return
        }
        isLoading = true
        
        guard let url = URL(string: "\(Constants.usersEndpoint)/\(userId)") else {
            self.error = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .sink(receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                switch completionResult {
                case .finished:
                    self?.fetchAllUsers()
                case .failure(let error):
                    self?.error = "Error deleting user: \(error.localizedDescription)"
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func updateUser(_ user: User) {
        guard let userId = user.id, !userId.isEmpty else {
            self.error = "Invalid user ID"
            return
        }
        print("Using token: \(token)")

        isLoading = true
        
        guard let url = URL(string: "\(Constants.usersEndpoint)/\(userId)") else {
            self.error = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            self.error = "Error encoding user: \(error.localizedDescription)"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .sink(receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                switch completionResult {
                case .finished:
                    self?.fetchAllUsers()
                case .failure(let error):
                    self?.error = "Error updating user: \(error.localizedDescription)"
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    var userCount: Int {
        return users.count
    }
}
