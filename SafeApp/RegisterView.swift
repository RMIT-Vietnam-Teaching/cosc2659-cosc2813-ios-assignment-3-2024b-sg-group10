import SwiftUI

struct RegisterView: View {
    @Binding var emailID: String
    @Binding var password: String
    @Binding var showRegister: Bool
    @State private var confirmPassword: String = ""

    var body: some View {
        VStack(spacing: 10) {
            CustomTextField(text: $emailID, hint: "Email Address", leadingIcon: Image(systemName: "envelope"))
            CustomTextField(text: $password, hint: "Password", leadingIcon: Image(systemName: "lock"), isPassword: true)
            CustomTextField(text: $confirmPassword, hint: "Confirm Password", leadingIcon: Image(systemName: "lock"), isPassword: true)
            
            Spacer(minLength: 10)
            
            Button(action: {}) {
                Text("Register")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color.black))
            }
            
            Button(action: { showRegister = false }) {
                Text("Back to Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.top, 10)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(emailID: .constant(""), password: .constant(""), showRegister: .constant(false))
    }
}
