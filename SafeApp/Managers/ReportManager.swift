import Foundation
import Combine

class ReportManager: ObservableObject {
    @Published var reports: [TrafficReport] = []

    func loadReports() {
        // Fetch reports from API or other source
        // Example:
        APIManager.shared.fetchTrafficReports { result in
            switch result {
            case .success(let fetchedReports):
                self.reports = fetchedReports
            case .failure(let error):
                print("Error fetching reports: \(error.localizedDescription)")
            }
        }
    }
}
