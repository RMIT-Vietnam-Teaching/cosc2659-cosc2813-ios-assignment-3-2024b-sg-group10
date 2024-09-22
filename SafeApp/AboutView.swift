//
//  AboutView.swift
//  SafeApp
//
//  Created by Minh Tran Nguyen Anh on 16/9/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text("About SafePath Vietnam ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    // Description
                    Text("""
                    SafePath Vietnam is a traffic safety reporting app designed to help users report and track traffic accidents in real-time. Our mission is to enhance road safety and provide valuable insights into traffic conditions across Vietnam.

                    With SafePath Vietnam, you can:
                    - Report traffic incidents quickly and easily.
                    - View real-time reports from other users.
                    - Access important safety tips and information.
                    - Get notifications about incidents and updates in your area.
                    
                    Our app is built with the latest technology to ensure accuracy and reliability, making your daily commute safer and more informed. Your safety is our top priority.
                    """)
                        .font(.body)
                        .padding(.horizontal)
                    
                    // Contact Information
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Contact Us")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("For any questions or feedback, please reach out to us at:")
                            .font(.body)
                        
                        Text("Email: support@safepath.vn")
                            .font(.body)
                        
                        Text("Phone: +84 123 456 789")
                            .font(.body)
                    }
                    .padding(.horizontal)
                    
                    // Footer
                    VStack {
                        Text("Thank you for using SafePath Vietnam!")
                            .font(.body)
                            .padding(.top)
                        
                        Text("© 2024 SafePath Vietnam. All rights reserved.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom)
            }
            .navigationTitle("About Us")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AboutView()
}
