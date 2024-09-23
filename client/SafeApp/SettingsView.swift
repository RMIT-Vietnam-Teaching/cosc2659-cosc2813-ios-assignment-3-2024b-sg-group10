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

struct SettingsView: View {
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    @AppStorage("selectedLanguage") var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "vi"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Appearance", selection: $selectedAppearance) {
                        Text("System").tag("system")
                        Text("Light Mode").tag("light")
                        Text("Dark Mode").tag("dark")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedAppearance) { _ in
                        // Handle updates, e.g., save preferences or update UI
                        print("UI has been updated")
                    }
                }
                Section(header: Text("Language")) {
                    Picker("Language", selection: $selectedLanguage) {
                        Text("Vietnamese").tag("vi")
                        Text("English").tag("en")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedLanguage) { newLanguage in
                        LanguageManager.shared.setLanguage(newLanguage)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
