import SwiftUI
import Foundation

struct ReportIncidentScreen: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    var latitude: String
    var longitude: String
    var token: String? // Token tùy chọn

    var body: some View {
        VStack(spacing: 20) {
            headerView
            
            inputField(title: "Title", text: $title, iconName: "pencil", placeholder: "Enter title here")
            inputField(title: "Description", text: $description, iconName: "text.justify", placeholder: "Enter description here")
            
            VStack(alignment: .leading, spacing: 10) {
                locationInfo(title: "Latitude", value: latitude)
                locationInfo(title: "Longitude", value: longitude)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
            
            submitButton
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if let token = token {
                print("Token: \(token)")
            } else {
                print("No token available")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
            
            Text("Report Incident")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 5)
        }
    }
    
    private func inputField(title: String, text: Binding<String>, iconName: String, placeholder: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .padding(.leading, 15)
            
            TextField(placeholder, text: text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .font(.body)
        }
        .padding(.horizontal)
    }
    
    private func locationInfo(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var submitButton: some View {
        Button(action: submitReport) {
            HStack {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                Text("Submit Report")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
        }
        .padding(.top, 20)
    }
    
    private func submitReport() {
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            showAlert(title: "Error", message: "Invalid latitude or longitude")
            return
        }
        
        // Tạo URL và yêu cầu HTTP cho báo cáo
        guard let reportUrl = URL(string: Constants.reportsEndpoint) else {
            showAlert(title: "Error", message: "Invalid URL")
            return
        }
        
        var reportRequest = URLRequest(url: reportUrl)
        reportRequest.httpMethod = "POST"
        reportRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            reportRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let reportData = [
            "title": title,
            "description": description,
            "location": [
                "latitude": lat,
                "longitude": lon
            ]
        ] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: reportData, options: [])
            reportRequest.httpBody = jsonData
            
            // Gửi yêu cầu báo cáo
            URLSession.shared.dataTask(with: reportRequest) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        showAlert(title: "Error", message: "Error sending report: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                        showAlert(title: "Error", message: "Unexpected response")
                        return
                    }
                    
                    sendNotification(title: "New Incident Reported", message: "A new incident has been reported.")
                }
            }.resume()
            
        } catch {
            showAlert(title: "Error", message: "Error encoding report data: \(error.localizedDescription)")
        }
    }
    
    private func sendNotification(title: String, message: String) {
        // Tạo URL và yêu cầu HTTP cho thông báo
        guard let notificationUrl = URL(string: Constants.notificationsEndpoint) else {
            showAlert(title: "Error", message: "Invalid URL for notifications")
            return
        }
        
        var notificationRequest = URLRequest(url: notificationUrl)
        notificationRequest.httpMethod = "POST"
        notificationRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            notificationRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let notificationData = [
            "title": title,
            "message": message
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: notificationData, options: [])
            notificationRequest.httpBody = jsonData
            
            // Gửi yêu cầu thông báo
            URLSession.shared.dataTask(with: notificationRequest) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        showAlert(title: "Error", message: "Error sending notification: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                        showAlert(title: "Error", message: "Unexpected response for notification")
                        return
                    }
                    
                    showAlert(title: "Success", message: "Report submitted and notification sent successfully")
                }
            }.resume()
            
        } catch {
            showAlert(title: "Error", message: "Error encoding notification data: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

struct ReportIncidentScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReportIncidentScreen(latitude: "10.762622", longitude: "106.660172", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmU3ZDQ3MGQxYWYzNmQ1ZjA2MTVhMGEiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MjY0NjkyMzIsImV4cCI6MTcyNjU1NTYzMn0.ZUfjBIwE55ftLyF6QjX_W16p3wDkVl7HJosIpZu5U3A")
    }
}
