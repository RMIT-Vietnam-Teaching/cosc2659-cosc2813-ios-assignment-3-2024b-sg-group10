//
//  AppMenu.swift
//  SafeApp
//
//  Created by Minh Tran Nguyen Anh on 16/9/24.
//

import SwiftUI

struct AppMenu: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "vi"
    @State private var showingProfilePage = false
    @State private var profileName: String = "John Doe"
    
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
                
                // Profile section
                VStack(alignment: .leading) {
                    HStack {
                        // User profile picture
                        Image(systemName: "person.circle.fill") // Placeholder image for profile picture
                            .resizable()
                            .frame(width: 90, height: 90)
                        VStack(alignment: .leading) {
                            Text("Hey \(profileName)!")
                                .font(.title2)
                                .fontWeight(.bold)
                            // Navigation to ProfilePage
                            NavigationLink(destination: ProfilePage(), isActive: $showingProfilePage) {
                                Button(action: {
                                    showingProfilePage = true
                                }) {
                                    Text("View Profile")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider().padding(.vertical)
                
                // Menu options
                VStack(alignment: .leading, spacing: 20) {
                    MenuOptionView(icon: "doc.text", title: "Statistics", colorScheme: colorScheme)
                    NavigationLink(destination: SafetyTipsScreen()) {
                        MenuOptionView(icon: "lightbulb", title: "Tips", colorScheme: colorScheme)
                    }
                    NavigationLink(destination: SettingsView()) {
                        MenuOptionView(icon: "gearshape", title: "Settings", colorScheme: colorScheme)
                    }
                    NavigationLink(destination: AboutView()) {
                        MenuOptionView(icon: "info.circle", title: "About", colorScheme: colorScheme)
                    }
                    MenuOptionView(icon: "arrow.backward.square", title: "Log Out", isDestructive: true, colorScheme: colorScheme)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .environment(\.locale, Locale(identifier: selectedLanguage))
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
