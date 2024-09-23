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

struct NotificationScreen: View {
    @StateObject private var viewModel: NotificationViewModel
    
    var token: String

    // Khởi tạo `viewModel` với giá trị `token`
    init(token: String) {
        _viewModel = StateObject(wrappedValue: NotificationViewModel(token: token))
        self.token = token
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Notifications")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, geometry.size.height * 0.05)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundColor(.primary) // Adaptive to dark mode
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
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
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct NotificationCardView: View {
    var notification: Notification
    
    @Environment(\.colorScheme) var colorScheme // Environment variable for detecting light/dark mode
    
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
                    .foregroundColor(.primary) // Adapts to light/dark mode
                
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
        .background(Color(UIColor.systemBackground)) // Adaptive background
        .cornerRadius(10)
        .shadow(color: shadowColor, radius: 5, x: 0, y: 5) // Responsive shadow based on dark/light mode
    }
    
    var shadowColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)
    }
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU2ZDI0N2Q3ZDdkZmQwMzZkNzc1ZjYiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY2NDY5OTUsImV4cCI6MTcyNjczMzM5NX0.S-i79_AMlkLUiQmvY4hgmYvrmx72WnwlN6PR7_bbIPY")
    }
}
