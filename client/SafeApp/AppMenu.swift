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

struct AppMenu: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var showingProfilePage = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Close button (X)
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Close the view
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            
                // Menu options
                VStack(alignment: .leading, spacing: 20) {
                    NavigationLink(destination: SafetyTipsScreen()) {
                        MenuOptionView(icon: "lightbulb", title: "Tips", colorScheme: colorScheme)
                    }
                    NavigationLink(destination: SettingsView()) {
                        MenuOptionView(icon: "gearshape", title: "Settings", colorScheme: colorScheme)
                    }
                    NavigationLink(destination: AboutView()) {
                        MenuOptionView(icon: "info.circle", title: "About", colorScheme: colorScheme)
                    }
                    
                    Button(action: {
                        logout() // Call the logout function
                    }) {
                        MenuOptionView(icon: "arrow.backward.square", title: "Log Out", isDestructive: true, colorScheme: colorScheme)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
    
    // Logout function to clear data and navigate to SplashView
    func logout() {
        // Clear user data or reset app state here
        UserDefaults.standard.removeObject(forKey: "userLoggedIn") // Example of clearing saved login state
        // Any additional resetting of app state should go here
        
        // Navigate to the SplashView
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: SplashView())
            window.makeKeyAndVisible()
        }
    }
}

struct MenuOptionView: View {
    var icon: String
    var title: String
    var isDestructive: Bool = false
    var colorScheme: ColorScheme

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? .red : (colorScheme == .dark ? .white : .black)) // Adjust icon color
                .font(.title2)
                .fontWeight(.semibold)
            Text(title)
                .foregroundColor(isDestructive ? .red : (colorScheme == .dark ? .white : .black))
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
        }
        .font(.headline)
        .padding(.vertical, 10)
    }
}

#Preview {
    AppMenu()
}
