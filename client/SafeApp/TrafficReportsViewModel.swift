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
    
    func createReport(_ report: TrafficReport) {
        let url = URL(string: "http://localhost:5001/api/reports")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(report)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TrafficReport.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error creating report: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] newReport in
                self?.reports.append(newReport)
            })
            .store(in: &cancellables)
    }
    
    func updateReport(_ report: TrafficReport) {
        guard let id = report.id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
        let url = URL(string: "http://localhost:5001/api/reports/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(report)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TrafficReport.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error updating report: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] updatedReport in
                if let index = self?.reports.firstIndex(where: { $0.id == updatedReport.id }) {
                    self?.reports[index] = updatedReport
                }
            })
            .store(in: &cancellables)
    }
    
    func deleteReport(_ id: String) {
        let url = URL(string: "http://localhost:5001/api/reports/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error deleting report: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                self?.reports.removeAll { $0.id == id }
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
                date: Date()
            )
        }
        self.notifications.append(contentsOf: newNotifications)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.fetchReports()
        }
    }
    
    var reportCount: Int {
            return reports.count
        }
}
