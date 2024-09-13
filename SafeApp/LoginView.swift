import SwiftUI

struct LoginView: View {
    @Binding var emailID: String
    @Binding var password: String
    @Binding var showRegister: Bool
    @Binding var isLoggedIn: Bool
    
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                VStack(alignment: .center, spacing: 10) {
                    Image("Page 3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 20)
                    
                    Text("Let's Get Started")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("To register for an account, kindly enter your details.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.bottom, 30)
                
                CustomTextField(text: $emailID, hint: "Email Address", leadingIcon: Image(systemName: "envelope"))
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .font(.callout)
                    
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1)))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gray, lineWidth: 1)
                )
                
                Spacer(minLength: 10)
                
                NavigationLink(destination: HomeScreen(), isActive: $isLoggedIn) {
                    Button(action: {
                        isLoggedIn = true
                    }) {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Capsule().fill(Color.black))
                    }
                }
                
                Button(action: { showRegister = true }) {
                    Text("Register")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            emailID: .constant(""),
            password: .constant(""),
            showRegister: .constant(false),
            isLoggedIn: .constant(false)
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
