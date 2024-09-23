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

struct AddContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var contacts: [EmergencyContact]
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Contact Information")
                        .font(.headline)
                        .foregroundColor(.blue)
                    ) {
                        HStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            }
                            
                            VStack(alignment: .leading) {
                                TextField("Name", text: $name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                                    .font(.title2)
                                
                                TextField("Phone Number", text: $phoneNumber)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                                    .font(.title2)
                                    .keyboardType(.phonePad)
                            }
                        }
                        .padding(.vertical)
                        
                        Button(action: {
                            showImagePicker.toggle()
                        }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .foregroundColor(.blue)
                                Text("Select Image")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical)
                    }
                }
                
                Spacer()
                
                Button(action: addContact) {
                    Text("Save Contact")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                .disabled(name.isEmpty || phoneNumber.isEmpty)
            }
            .navigationTitle("Add New Contact")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private func addContact() {
        let newContact = EmergencyContact(name: name, phoneNumber: phoneNumber, image: selectedImage)
        contacts.append(newContact)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView(contacts: .constant([]))
    }
}
