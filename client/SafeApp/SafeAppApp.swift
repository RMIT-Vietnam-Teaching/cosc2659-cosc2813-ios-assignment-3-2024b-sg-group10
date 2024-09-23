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

@main
struct SafeAppApp: App {
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    @AppStorage("selectedLanguage") var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "vi"

    var body: some Scene {
        WindowGroup {
            SplashView()
                .onAppear {
                    // Apply the color scheme when the app first loads
                    applyAppearance()
                }
                .onChange(of: selectedAppearance) { _ in
                    // Trigger the change when the selectedAppearance changes
                    applyAppearance()
                }
                .environment(\.locale, Locale(identifier: selectedLanguage))
        }
    }
    
    private func applyAppearance() {
        // Set the color scheme based on the selectedAppearance value
        let appearance = getColorScheme(for: selectedAppearance)
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = appearance == .dark ? .dark : appearance == .light ? .light : .unspecified
    }
    
    private func getColorScheme(for appearance: String) -> UIUserInterfaceStyle {
        switch appearance {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return .unspecified  // Use system default
        }
    }
}
