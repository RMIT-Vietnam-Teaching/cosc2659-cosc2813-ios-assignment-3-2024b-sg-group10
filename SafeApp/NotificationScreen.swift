import SwiftUI

struct NotificationScreen: View {
    @Binding var notifications: [Notification] // Use a Binding to modify the notifications array
    
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            ScrollView {
                ForEach(notifications) { notification in
                    NotificationCardView(notification: notification)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                }
            }
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
                
                Text(notification.content)
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
    @State static var sampleNotifications = Notification.getSampleNotifications()
    
    static var previews: some View {
        NotificationScreen(notifications: $sampleNotifications)
    }
}
