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

struct UpdateNotificationView: View {
    @ObservedObject var viewModel: NotificationViewModel
    @State private var title: String
    @State private var message: String
    @State private var date: Date
    
    let notification: Notification
    
    init(viewModel: NotificationViewModel, notification: Notification) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _title = State(initialValue: notification.title)
        _message = State(initialValue: notification.message)
        _date = State(initialValue: notification.date)
        self.notification = notification
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notification Details")) {
                    TextField("Title", text: $title)
                    TextField("Message", text: $message)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Button(action: updateNotification) {
                    Text("Update Notification")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(viewModel.isLoading)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                }
            }
            .navigationTitle("Update Notification")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func updateNotification() {
        let updatedNotification = Notification(
            id: notification.id,
            title: title,
            message: message,
            date: date // Use Date directly
        )
        
        viewModel.updateNotification(id: notification.id, notification: updatedNotification) { success in
            if success {
                // Handle success (e.g., dismiss view, show alert)
            } else {
                // Handle error (e.g., show error message)
            }
        }
    }
}

struct UpdateNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateNotificationView(
            viewModel: NotificationViewModel(token: "your-token-here"),
            notification: Notification(
                id: "1",
                title: "Sample Notification",
                message: "This is a sample notification message.",
                date: Date() // Use Date directly for preview
            )
        )
    }
}
