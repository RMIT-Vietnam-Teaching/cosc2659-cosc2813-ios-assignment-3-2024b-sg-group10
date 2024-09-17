import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel: TrafficReportsViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3347302, longitude: -122.0089189),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var timeRemaining = 60
    private let updateInterval: TimeInterval = 60 
    
    private var timer: Timer? {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateCountdown()
        }
    }

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
                startTimer()
            }

            Text("Next update in: \(formattedTimeRemaining)")
                .font(.headline)
                .padding()
                .foregroundColor(.gray)
        }
    }

    private func startTimer() {
        timer?.invalidate() // Invalidate previous timer if any
        timeRemaining = Int(updateInterval)
        _ = timer // Start the new timer
    }

    private func updateCountdown() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            viewModel.fetchReports()
            timeRemaining = Int(updateInterval)
        }
    }

    private var formattedTimeRemaining: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Preview for MapView
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU3ZDQ3MGQxYWYzNmQ1ZjA2MTVhMGEiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY0NjkyMzIsImV4cCI6MTcyNjU1NTYzMn0.ZUfjBIwE55ftLyF6QjX_W16p3wDkVl7HJosIpZu5U3A")
            .previewLayout(.sizeThatFits)
    }
}
