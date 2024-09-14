//
//  ProfilePage.swift
//  SafeApp
//
//  Created by Minh Tran Nguyen Anh on 14/9/24.
//

import SwiftUI

struct ProfilePage: View {
    
    @State private var isEditing = false
    @State private var name = "John Doe"
    @State private var username = "@JohnDoe123"
    @State private var email = "john.doe@example.com"
    @State private var phoneNumber = "1234567890"
    @State private var address = "123 Main St"
    @State private var birthdate = Date()
    
    @State private var showImagePicker = false
    @State private var avatarImage: UIImage? = UIImage(named: "test-avatar")
    
    var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    showImagePicker = true
                }) {
                    Image(uiImage: avatarImage ?? UIImage(named: "test-avatar")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                }
                .sheet(isPresented: $showImagePicker) {
                    GeometryReader { geometry in
                        ImagePicker(image: $avatarImage)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(username)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .padding()
            
            VStack(alignment: .leading) {
                fieldWithIcon(iconName: "person.fill", placeholder: "Name", text: $name, isEditing: $isEditing)
                fieldWithIcon(iconName: "envelope.fill", placeholder: "Email", text: $email, isEditing: $isEditing)
                fieldWithIcon(iconName: "phone.fill", placeholder: "Phone Number", text: Binding(
                    get: { phoneNumber },
                    set: { newValue in
                        // Filter to allow only digits
                        phoneNumber = newValue.filter { $0.isNumber }
                    }), isEditing: $isEditing, keyboardType: .phonePad)
                fieldWithIcon(iconName: "house.fill", placeholder: "Address", text: $address, isEditing: $isEditing)
                
                HStack {
                    Image(systemName: "calendar") // Example icon
                        .foregroundColor(.gray)
                    if isEditing {
                        DatePicker("", selection: $birthdate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden() // Hide default label
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(birthdate, style: .date)
                            .padding(8)
                            .foregroundColor(.gray)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding(.vertical, 5)
            }
            .padding(.horizontal)
            .padding(.vertical)
                    
            Button(action: {
                isEditing.toggle()
                
                if !isEditing {
                    saveProfile()
                }
                
            }) {
                Text(isEditing ? "Save Profile" : "Edit Profile")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .background(.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0))
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func saveProfile() {
        // Implement save logic
    }
    
    // Helper view for consistent field styling
    private func fieldWithIcon(iconName: String, placeholder: String, text: Binding<String>, isEditing: Binding<Bool>, keyboardType: UIKeyboardType = .default) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(!isEditing.wrappedValue)
                .foregroundColor(isEditing.wrappedValue ? .primary : .gray)
        }
        .padding(.vertical, 5) // Add vertical padding to each field
    }
}

#Preview {
    ProfilePage()
}
