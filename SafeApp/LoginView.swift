import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()

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

                CustomTextField(text: $viewModel.emailID, hint: "Email Address", leadingIcon: Image(systemName: "envelope"))

                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .font(.callout)

                    if viewModel.isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(PlainTextFieldStyle())
                    }

                    Button(action: {
                        viewModel.isPasswordVisible.toggle()
                    }) {
                        Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))

                Spacer(minLength: 10)

                NavigationLink(destination: HomeDashboardView(), isActive: $viewModel.isLoggedInAdmin) {
                    EmptyView()
                }

                if let token = viewModel.token {
                    NavigationLink(destination: HomeScreen(token: token), isActive: $viewModel.isLoggedInUser) {
                        EmptyView()
                    }
                }

                if !viewModel.isLoggedInAdmin && !viewModel.isLoggedInUser {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.vertical, 15)
                    } else {
                        Button(action: {
                            viewModel.loginUser()
                        }) {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity)
                                .background(Capsule().fill(Color.black))
                        }
                    }
                }

                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
            }
            .padding()
            .alert(item: $viewModel.errorMessage) { error in
                Alert(
                    title: Text("Login"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

