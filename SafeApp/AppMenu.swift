//
//  AppMenu.swift
//  SafeApp
//
//  Created by Minh Tran Nguyen Anh on 16/9/24.
//

import SwiftUI

struct AppMenu: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                        Text("Hey John Doe!")
                            .font(.title2)
                            .fontWeight(.bold)
                        Button(action: {
                            // Action to view profile
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
                .padding(.horizontal)
            }
            
            Divider().padding(.vertical)
            
            // Menu options
            VStack(alignment: .leading, spacing: 20) {
                MenuOptionView(icon: "doc.text", title: "Statistics")
                MenuOptionView(icon: "lightbulb", title: "Tips")
                MenuOptionView(icon: "gearshape", title: "Settings")
                MenuOptionView(icon: "info.circle", title: "About")
                MenuOptionView(icon: "arrow.backward.square", title: "Log Out", isDestructive: true)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct MenuOptionView: View {
    var icon: String
    var title: String
    var isDestructive: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? .red : .black)
            Text(title)
                .foregroundColor(isDestructive ? .red : .black)
            Spacer()
        }
        .font(.headline)
        .padding(.vertical, 10)
    }
}

#Preview {
    AppMenu()
}
