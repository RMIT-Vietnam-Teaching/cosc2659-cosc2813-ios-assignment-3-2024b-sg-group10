//
//  SettingsView.swift
//  SafeApp
//
//  Created by Minh Tran Nguyen Anh on 16/9/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    
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
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
