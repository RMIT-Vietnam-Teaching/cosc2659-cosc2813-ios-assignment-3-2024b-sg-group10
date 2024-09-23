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
