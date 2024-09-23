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

struct TrafficReportListView: View {
    @StateObject private var viewModel: TrafficReportsViewModel
    @State private var showDeleteConfirmation = false
    @State private var reportToDelete: TrafficReport?

    init(token: String) {
        _viewModel = StateObject(wrappedValue: TrafficReportsViewModel(token: token))
    }

    var body: some View {
        VStack {
            if viewModel.reports.isEmpty {
                Text("No reports available")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(viewModel.reports) { report in
                        HStack {
                            NavigationLink(destination: TrafficReportDetailView(report: report, viewModel: viewModel)) {
                                TrafficReportRow(report: report)
                            }
                            Spacer()
                            Button(action: {
                                reportToDelete = report
                                showDeleteConfirmation = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .onAppear {
            viewModel.fetchReports()
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Report"),
                message: Text("Are you sure you want to delete this report?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let report = reportToDelete {
                        viewModel.deleteReport(report.id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct TrafficReportRow: View {
    let report: TrafficReport

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(report.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(report.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
                if let createdDate = report.createdDate {
                    Text("Created on: \(createdDate, formatter: dateFormatter)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .frame(height: 120)
        .padding(.horizontal)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct TrafficReportDetailView: View {
    let report: TrafficReport
    @ObservedObject var viewModel: TrafficReportsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(report.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                
                Text(report.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Location:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("Lat: \(report.location.latitude), Lon: \(report.location.longitude)")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)

                    if let createdDate = report.createdDate {
                        HStack {
                            Text("Created on:")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(createdDate, formatter: dateFormatter)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
            }
            .padding()
        }
        .navigationBarTitle("Report Details", displayMode: .inline)
    }
}


struct TrafficReportListView_Previews: PreviewProvider {
    static var previews: some View {
        TrafficReportListView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU2ZDI0N2Q3ZDdkZmQwMzZkNzc1ZjYiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY2NzQ4MjksImV4cCI6MTcyNjc2MTIyOX0.75A1enpELcmD68TbO5Aw4kv-vxOY9LhVwDYg7fP7QT0")
            .environmentObject(TrafficReportsViewModel(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU2ZDI0N2Q3ZDdkZmQwMzZkNzc1ZjYiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY2NzQ4MjksImV4cCI6MTcyNjc2MTIyOX0.75A1enpELcmD68TbO5Aw4kv-vxOY9LhVwDYg7fP7QT0"))
    }
}



