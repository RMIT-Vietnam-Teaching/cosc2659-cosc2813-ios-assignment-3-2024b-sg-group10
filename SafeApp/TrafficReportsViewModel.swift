import Foundation
import Combine

class TrafficReportsViewModel: ObservableObject {
    @Published var reports: [TrafficReport] = []
    @Published var notifications: [Notification] = []
    private var cancellables = Set<AnyCancellable>()
    private let token: String
    private var timer: Timer?
    
    init(token: String) {
        self.token = token
        fetchReports()
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func fetchReports() {
        let url = URL(string: "http://localhost:5001/api/reports")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [TrafficReport].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching reports: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] reports in
                self?.reports = reports
                self?.updateNotifications(with: reports)
            })
            .store(in: &cancellables)
    }
    
    private func updateNotifications(with reports: [TrafficReport]) {
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let newNotifications = reports.map { report in
            Notification(
                id: report.id,
                title: report.title,
                message: report.description,
                date: dateFormatter.string(from: Date())            )
        }
        self.notifications.append(contentsOf: newNotifications)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.fetchReports()
        }
    }
}
