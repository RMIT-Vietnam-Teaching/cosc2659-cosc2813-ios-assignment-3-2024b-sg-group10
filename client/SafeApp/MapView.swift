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
import MapKit

struct MapView: View {
    @StateObject private var viewModel: TrafficReportsViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3347302, longitude: -122.0089189),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    private let updateInterval: TimeInterval = 60
    @State private var timer: Timer? // Sử dụng @State để quản lý Timer
    @Environment(\.colorScheme) var colorScheme // Detect system appearance (dark or light mode)

    init(token: String) {
        _viewModel = StateObject(wrappedValue: TrafficReportsViewModel(token: token))
    }

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: viewModel.reports) { report in
                MapAnnotation(coordinate: report.location.location) {
                    VStack {
                        // Adjust the pin color based on dark or light mode
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(colorScheme == .dark ? .yellow : .red)
                            .font(.title)

                        Text(report.title)
                            .font(.caption)
                            .padding(5)
                            .background(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
            .onAppear {
                viewModel.fetchReports()
                startAutoUpdate()
            }
        }
    }

    private func startAutoUpdate() {
        timer?.invalidate() // Hủy bỏ timer trước đó (nếu có)
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
            viewModel.fetchReports()
        }
    }
}

// Preview for MapView
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU2ZDI0N2Q3ZDdkZmQwMzZkNzc1ZjYiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY2NDY5OTUsImV4cCI6MTcyNjczMzM5NX0.S-i79_AMlkLUiQmvY4hgmYvrmx72WnwlN6PR7_bbIPY")
            .previewLayout(.sizeThatFits)
    }
}
