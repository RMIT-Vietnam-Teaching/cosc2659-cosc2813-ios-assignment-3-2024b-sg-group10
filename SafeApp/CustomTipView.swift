import SwiftUI

struct CustomTipView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("User Guide")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 15)
            
            HStack {
                Image(systemName: "map")
                    .font(.body)
                    .foregroundColor(.blue)
                Text("Use the map to view traffic incident reports.")
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "plus.circle")
                    .font(.body)
                    .foregroundColor(.blue)
                Text("Tap the plus button to report a new incident.")
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "bell")
                    .font(.body)
                    .foregroundColor(.blue)
                Text("Tap the bell icon to view notifications.")
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
