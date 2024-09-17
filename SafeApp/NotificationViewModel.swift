import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let token: String
    
    init(token: String) {
        self.token = token
        fetchNotifications()
    }
    
    func fetchNotifications() {
        isLoading = true
        let url = URL(string: "http://localhost:5001/api/notifications")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [NotificationResponse].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = "Error fetching notifications: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.notifications = response.map { Notification(
                    id: $0._id,
                    title: $0.title,
                    message: $0.message,
                    date: $0.date
                )}
            })
            .store(in: &cancellables)
    }
}
