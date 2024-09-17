import SwiftUI
import MapKit

struct HomeScreen: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var reportManager = ReportManager()
    @StateObject private var locationManager = LocationManager()
    @State private var showingReportSheet = false
    @State private var showingNotificationSheet = false
    @State private var showingAppMenu = false
    @State private var showingTip = false
    @State private var selectedCautionType: String = ""
    @State private var notifications: [Notification] = Notification.getSampleNotifications()
    @State private var shouldRecenter = false // State to trigger recentering the map
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView(
                    userLocation: Binding(
                        get: { locationManager.location?.coordinate },
                        set: { _ in }
                    ),
                    shouldRecenter: $shouldRecenter, // Ensure shouldRecenter comes before reports
                    reports: reportManager.reports
                )


                VStack {
                    Spacer()
                    
                    if let placeName = locationManager.placeName {
                        Text("You are at \(placeName)")
                            .font(.subheadline)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                    
                    HStack {
                        Spacer()
                        
                        // Re-center Button
                        Button(action: {
                            shouldRecenter = true // Trigger recentering the map
                        }) {
                            Image(systemName: "location.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(.trailing)
                        
                        Button(action: {
                            showingTip.toggle()
                        }) {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(colorScheme == .dark ? .white : .blue)
//                                .padding()
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
                                .foregroundColor(colorScheme == .dark ? .white : .blue)
                                .padding(.horizontal)
                        }
                        .sheet(isPresented: $showingReportSheet) {
                            ReportIncidentScreen(selectedCautionType: $selectedCautionType)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("SafePath Vietnam")
            .navigationBarItems(
                leading: Button(action: {
                    showingAppMenu.toggle()
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : .blue)
                },
                
                trailing: Button(action: {
                showingNotificationSheet.toggle()
            }) {
                ZStack {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .foregroundColor(colorScheme == .dark ? .white : .blue)

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
            .sheet(isPresented: $showingAppMenu, onDismiss: nil){
                AppMenu()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
