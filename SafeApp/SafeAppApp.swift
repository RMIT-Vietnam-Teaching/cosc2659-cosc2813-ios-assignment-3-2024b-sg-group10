//
//  AboutView.swift
//  SafeApp
//
//  Created by Minh Tran Nguyen Anh on 16/9/24.
//

import SwiftUI

@main
struct SafeAppApp: App {
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    
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

