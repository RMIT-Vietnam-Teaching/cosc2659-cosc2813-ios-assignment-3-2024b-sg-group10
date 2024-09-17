import SwiftUI
import MapKit

struct HomeScreen: View {
    @StateObject private var reportManager = ReportManager()
    @StateObject private var locationManager = LocationManager()
    @State private var showingReportSheet = false
    @State private var showingNotificationSheet = false
    @State private var showingTip = false
    @State private var notifications: [Notification] = []
    var token: String?

    var body: some View {
        NavigationView {
            ZStack {
                // Map View with reports
                MapView(token: token ?? "")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    if let placeName = locationManager.placeName {
                        Text("Bạn đang ở \(placeName)")
                            .font(.subheadline)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingTip.toggle()
                        }) {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .popover(isPresented: $showingTip) {
                            CustomTipView()
                                .previewLayout(.sizeThatFits)
                                .padding()
                        }
                        
                        Button(action: {
                            showingReportSheet.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .sheet(isPresented: $showingReportSheet) {
                            if let location = locationManager.location {
                                ReportIncidentScreen(
                                    latitude: String(location.coordinate.latitude),
                                    longitude: String(location.coordinate.longitude),
                                    token: token
                                )
                            } else {
                                ReportIncidentScreen(
                                    latitude: "Unknown",
                                    longitude: "Unknown"
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("SafePath Vietnam")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                showingNotificationSheet.toggle()
            }) {
                ZStack {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    if notifications.count > 0 {
                        Text("\(notifications.count)")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    }
                }
            })
            .sheet(isPresented: $showingNotificationSheet) {
                NotificationScreen(token: token ?? "")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
