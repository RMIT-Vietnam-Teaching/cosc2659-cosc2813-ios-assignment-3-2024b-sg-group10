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

struct CustomTipView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("Hướng dẫn sử dụng")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 15)
            
            HStack {
                Image(systemName: "map")
                    .font(.body)
                    .foregroundColor(.blue)
                Text("Sử dụng bản đồ để xem các báo cáo sự cố giao thông.")
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "plus.circle")
                    .font(.body)
                    .foregroundColor(.blue)
                Text("Nhấn vào nút cộng để báo cáo sự cố mới.")
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "bell")
                    .font(.body)
                    .foregroundColor(.blue)
                Text("Nhấn vào biểu tượng chuông để xem thông báo.")
                    .font(.body)
            }
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct CustomTipView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTipView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
