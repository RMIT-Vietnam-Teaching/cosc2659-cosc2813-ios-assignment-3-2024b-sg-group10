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
import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    var token: String {
        didSet {
            fetchNotifications()
        }
    }
    
    init(token: String) {
        self.token = token
        fetchNotifications()
    }
    
    func fetchNotifications() {
        isLoading = true
        guard let url = URL(string: Constants.notificationsEndpoint) else {
            self.error = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [NotificationResponse].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = "Error fetching notifications: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.notifications = response.map { Notification(
                    id: $0._id,
                    title: $0.title,
                    message: $0.message,
                    date: DateFormatter.iso8601.date(from: $0.date) ?? Date()
                )}
            })
            .store(in: &cancellables)
    }
    
    func updateNotification(id: String, notification: Notification, completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        guard let url = URL(string: "http://localhost:5001/api/notifications/\(id)") else {
            self.error = "Invalid URL"
            isLoading = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(notification)
        } catch {
            self.error = "Failed to encode notification"
            isLoading = false
            completion(false)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Notification.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                switch completionResult {
                case .finished:
                    completion(true)
                case .failure(let error):
                    self?.error = error.localizedDescription
                    completion(false)
                }
            }, receiveValue: { _ in
                // Handle successful update if needed
                self.fetchNotifications() // Refresh notifications after update
            })
            .store(in: &cancellables)
    }
    
    func deleteNotification(_ notification: Notification) {
        isLoading = true
        
        guard let url = URL(string: "http://localhost:5001/api/notifications/\(notification.id)") else {
            self.error = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.fetchNotifications() // Refresh notifications after deletion
                case .failure(let error):
                    self?.error = "Error deleting notification: \(error.localizedDescription)"
                }
            }, receiveValue: { _ in
                // Handle successful deletion if needed
            })
            .store(in: &cancellables)
    }
    
    func editNotification(_ notification: Notification) {
        // Navigate to the edit screen if needed
    }
    
    var notificationCount: Int {
           return notifications.count
       }
       
}
