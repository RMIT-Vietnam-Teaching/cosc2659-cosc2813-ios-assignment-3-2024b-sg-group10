import SwiftUI

struct UserUpdateView: View {
    @ObservedObject var viewModel: UserViewModel
    @Binding var user: User
    @State private var isEditing: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("User Information")) {
                    TextField("Email", text: $user.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Role", text: $user.role)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    if let avatarURL = user.avatar, !avatarURL.isEmpty {
                        AsyncImage(url: URL(string: avatarURL)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                
                Section {
                    Button(action: updateUser) {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Update Failed"),
                            message: Text(viewModel.error ?? "An unknown error occurred"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
        }
        .navigationTitle("Update Profile")
        .navigationBarItems(trailing: Button(action: { isEditing.toggle() }) {
            Text(isEditing ? "Done" : "Edit")
                .foregroundColor(.blue)
        })
        .onAppear {
            viewModel.fetchUserById(userId: user.id ?? "")
        }
    }
    
    private func updateUser() {
        viewModel.updateUser(user)
        if let error = viewModel.error {
            showAlert = true
        }
    }
}

struct UserUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview
        let sampleUser = User(id: "123", email: "example@example.com", role: "User", avatar: "https://via.placeholder.com/100")
        let viewModel = UserViewModel(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NmViZjM4MTVlZTIyNTcyMjllYWNjMTkiLCJyb2xlIjoidXNlciIsImlhdCI6MTcyNjczOTMyOSwiZXhwIjoxNzI2ODI1NzI5fQ.zqeltQkZAwasTsSJHGsOAKtBEWAsUgy0TujvNrU7ysA") // Placeholder token
        
        return UserUpdateView(viewModel: viewModel, user: .constant(sampleUser))
    }
}
