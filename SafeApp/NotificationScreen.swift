import SwiftUI

struct NotificationScreen: View {
    @StateObject private var viewModel: NotificationViewModel
    
    init(token: String) {
        _viewModel = StateObject(wrappedValue: NotificationViewModel(token: token))
    }
    
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    ForEach(viewModel.notifications) { notification in
                        NotificationCardView(notification: notification)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchNotifications()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

struct NotificationCardView: View {
    var notification: Notification
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "bell.fill")
                .foregroundColor(.white)
                .padding(10)
                .background(Circle().fill(Color.blue))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Text("Date: \(notification.dateFormatted)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 5)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU3ZDQ3MGQxYWYzNmQ1ZjA2MTVhMGEiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY0NjkyMzIsImV4cCI6MTcyNjU1NTYzMn0.ZUfjBIwE55ftLyF6QjX_W16p3wDkVl7HJosIpZu5U3A")
    }
}
