import SwiftUI
import MapKit

struct HomeScreen: View {
    @StateObject private var reportManager = ReportManager()
    @StateObject private var locationManager = LocationManager()  // Use LocationManager to get current location
    @State private var showingReportSheet = false
    @State private var showingNotificationSheet = false
    @State private var showingTip = false
    @State private var notifications: [Notification] = Notification.getSampleNotifications()
    
    // New state to handle selected caution type
    @State private var selectedCautionType: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // MapView showing all the reports
                MapView(reports: reportManager.reports)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Display place name if available
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
                        
                        // Info button for tips
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
                        
                        // Button to show the report incident screen
                        Button(action: {
                            showingReportSheet.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding()
                        }
                        // Open the report incident sheet and pass current location to it
                        .sheet(isPresented: $showingReportSheet) {
                            if let location = locationManager.location {
                                ReportIncidentScreen(
                                    selectedCautionType: $selectedCautionType,
                                    onSubmit: { newReport in
                                        reportManager.addReport(newReport)  
                                    },
                                    currentLocation: location.coordinate  // Pass the current location
                                )
                            } else {
                                Text("Unable to fetch your location.")
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("SafePath Vietnam")
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
                NotificationScreen(notifications: $notifications)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
