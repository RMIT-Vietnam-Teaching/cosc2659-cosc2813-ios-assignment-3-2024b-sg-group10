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

    init(token: String) {
        _viewModel = StateObject(wrappedValue: TrafficReportsViewModel(token: token))
    }

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: viewModel.reports) { report in
                MapAnnotation(coordinate: report.location.location) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text(report.title)
                            .font(.caption)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .shadow(radius: 5)
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
