import SwiftUI

struct ContactForm: View {
    @Binding var name: String
    @Binding var phoneNumber: String
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    
    var body: some View {
        Section(header: Text("Contact Information")) {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Phone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .padding(.vertical)
            }
            
            Button("Select Image") {
                showImagePicker.toggle()
            }
        }
    }
}
