import SwiftUI

struct HomeDashboardView: View {
    @StateObject private var userViewModel: UserViewModel
    @StateObject private var notificationViewModel: NotificationViewModel
    @StateObject private var trafficReportViewModel: TrafficReportsViewModel
    @State private var token: String? = UserDefaults.standard.string(forKey: "userToken")
    @State private var showingProfile = false
    @State private var isDarkMode = false
    @State private var isLoggedOut = false

    init() {
        let token = UserDefaults.standard.string(forKey: "userToken") ?? ""
        _userViewModel = StateObject(wrappedValue: UserViewModel(token: token))
        _notificationViewModel = StateObject(wrappedValue: NotificationViewModel(token: token))
        _trafficReportViewModel = StateObject(wrappedValue: TrafficReportsViewModel(token: token))
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: isDarkMode ? [Color.black, Color.gray] : [Color.blue.opacity(0.6), Color.purple.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerView
                        statisticsSection
                        quickAccessSection

                        Spacer()

                        logoutButton
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingProfile.toggle() }) {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Button(action: { isDarkMode.toggle() }) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                // Thêm nội dung cho sheet nếu cần
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear { print("Token: \(token ?? "No token available")") }
        .fullScreenCover(isPresented: $isLoggedOut) { LoginView() }
    }

    var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome back,")
                    .font(.title2)
                    .foregroundColor(.white)
                Text("Admin")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.title)
                    .foregroundColor(.yellow)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
    }

    var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(.white)
            HStack(spacing: 20) {
                statisticCard(icon: "person.3.fill", value: "\(userViewModel.userCount)")
                statisticCard(icon: "bell.fill", value: "\(notificationViewModel.notificationCount)")
                statisticCard(icon: "exclamationmark.triangle.fill", value: "\(trafficReportViewModel.reportCount)")
            }
            .frame(maxWidth: .infinity) // Đảm bảo hàng chứa thẻ có cùng kích thước
        }
    }


    func statisticCard(icon: String, value: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 100, height: 100) // Thiết lập kích thước cố định cho thẻ
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
    var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Access")
                .font(.headline)
                .foregroundColor(.white)
            HStack(spacing: 20) {
                NavigationLink(destination: NotificationListView(token: token ?? "")) {
                    quickAccessButton(title: "Notifications", image: "bell.fill")
                }
                NavigationLink(destination: TrafficReportListView(token: token ?? "")) {
                    quickAccessButton(title: "Traffic Reports", image: "exclamationmark.triangle.fill")
                }
                NavigationLink(destination: UserListView(token: token ?? "")) {
                    quickAccessButton(title: "User List", image: "person.3.fill")
                }
            }
        }
    }

    func quickAccessButton(title: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .font(.title)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
                .font(.footnote)
        }
        .frame(width: 80, height: 80) // Thiết lập kích thước cố định cho nút
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }

    var logoutButton: some View {
        Button(action: {
            UserDefaults.standard.removeObject(forKey: "userToken")
            isLoggedOut = true
        }) {
            Text("Logout")
                .fontWeight(.semibold)
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
        }
    }
}

struct HomeDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        HomeDashboardView()
    }
}
