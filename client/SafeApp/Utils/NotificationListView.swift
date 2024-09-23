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

struct NotificationListView: View {
    @StateObject private var viewModel: NotificationViewModel

    init(token: String) {
        _viewModel = StateObject(wrappedValue: NotificationViewModel(token: token))
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.notifications.isEmpty {
                    Text("No notifications available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.notifications) { notification in
                            NavigationLink(destination: UpdateNotificationView(viewModel: viewModel, notification: notification)) {
                                NotificationRow(viewModel: viewModel, notification: notification)
                                    .frame(height: 120) // Set fixed height for each row
                            }
                            .buttonStyle(PlainButtonStyle()) // Remove default button style
                        }
                    }
                    .listStyle(PlainListStyle()) // Use PlainListStyle for a cleaner look
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchNotifications()
            }
        }
    }
}

struct NotificationRow: View {
    @ObservedObject var viewModel: NotificationViewModel
    let notification: Notification

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(notification.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(notification.message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(notification.dateFormatted)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )

            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    // Handle delete action
                    viewModel.deleteNotification(notification)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1), in: Circle())
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock ViewModel for preview
        let mockViewModel = NotificationViewModel(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU2ZDI0N2Q3ZDdkZmQwMzZkNzc1ZjYiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY2NjA0MDUsImV4cCI6MTcyNjc0NjgwNX0.J7K1pL8AhyV-OBS-9yFr7PjD6AtR8FcYkKq0LmInQqw")
        mockViewModel.notifications = [
            Notification(id: "1", title: "Sample Notification 1", message: "This is the first sample notification message.", date: Date()),
            Notification(id: "2", title: "Sample Notification 2", message: "This is the second sample notification message.", date: Date())
        ]
        
        return NotificationListView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU2ZDI0N2Q3ZDdkZmQwMzZkNzc1ZjYiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY2NjA0MDUsImV4cCI6MTcyNjc0NjgwNX0.J7K1pL8AhyV-OBS-9yFr7PjD6AtR8FcYkKq0LmInQqw")
            .environmentObject(mockViewModel)
    }
}
