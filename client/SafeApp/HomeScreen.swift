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

struct HomeScreen: View {
    @StateObject private var reportManager = ReportManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationViewModel: NotificationViewModel
    @State private var showingReportSheet = false
    @State private var showingNotificationSheet = false
    @State private var showingTip = false
    @State private var showingUserUpdateSheet = false
    @State private var showingAppMenu = false
    var token: String?

    init(token: String?) {
        _notificationViewModel = StateObject(wrappedValue: NotificationViewModel(token: token ?? ""))
        self.token = token
    }

    var body: some View {
//        NavigationView {
            ZStack {
                MapView(token: token ?? "")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        // Hamburger button for app menu
                        Button(action: {
                            showingAppMenu.toggle()
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .sheet(isPresented: $showingAppMenu) {
                            AppMenu()
                        }

                        Spacer()

                        Button(action: {
                            showingNotificationSheet.toggle()
                        }) {
                            ZStack {
                                Image(systemName: "bell.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)

                                if notificationViewModel.notifications.count > 0 {
                                    Text("\(notificationViewModel.notifications.count)")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                        .padding()
                        .sheet(isPresented: $showingNotificationSheet) {
                            NotificationScreen(token: token ?? "")
                        }

                        Button(action: {
                            showingUserUpdateSheet.toggle()
                        }) {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .sheet(isPresented: $showingUserUpdateSheet) {
                            UpdateUserView(token: token ?? "")
                        }
                    }

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

                        Button(action: {
                            showingReportSheet.toggle()
                        }) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .sheet(isPresented: $showingReportSheet) {
                            ReportIncidentScreen(latitude: "\(locationManager.location?.coordinate.latitude ?? 0.0)", longitude: "\(locationManager.location?.coordinate.longitude ?? 0.0)", token: token)
                        }

                        NavigationLink(destination: SafetyTipsScreen()) {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding()

                        NavigationLink(destination: EmergencyContactsScreen()) {
                            Image(systemName: "phone.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .onAppear {
                locationManager.startUpdatingLocation()
            }
//        }
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(token: "fake_token")
            .environmentObject(LocationManager())
            .environmentObject(ReportManager())
    }
}
