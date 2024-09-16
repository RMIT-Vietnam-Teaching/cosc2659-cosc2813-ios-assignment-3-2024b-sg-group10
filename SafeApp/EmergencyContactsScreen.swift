import SwiftUI

struct EmergencyContactsScreen: View {
    @State private var contacts: [EmergencyContact] = [
        EmergencyContact(name: "Police", phoneNumber: "113", image: UIImage(named: "policeIcon")),
        EmergencyContact(name: "Fire Department", phoneNumber: "114", image: UIImage(named: "fireIcon")),
        EmergencyContact(name: "Ambulance", phoneNumber: "115", image: UIImage(named: "ambulanceIcon")),
    ]
    
    @State private var showAddContactView = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(contacts) { contact in
                        HStack {
                            if let image = contact.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                Text(contact.phoneNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                callNumber(contact.phoneNumber)
                            }) {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                    .padding()
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: deleteContact)
                }
                .listStyle(InsetGroupedListStyle())
                
                Button(action: { showAddContactView.toggle() }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                        Text("Add New Contact")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
                .sheet(isPresented: $showAddContactView) {
                    AddContactView(contacts: $contacts)
                }
            }
            .navigationTitle("Emergency Contacts")
        }
    }
    
    private func callNumber(_ phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func deleteContact(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
}

struct EmergencyContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactsScreen()
    }
}
