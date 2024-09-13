import SwiftUI

struct SplashView: View {
    @State private var activeIntro: PageIntro = pageIntros[0]
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var showRegister: Bool = false
    @State private var navigateToLogin: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            VStack {
                IntroView(intro: $activeIntro, size: size) {
                    // Khi đến trang cuối cùng, chuyển đến LoginView
                    navigateToLogin = true
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(15)
            .offset(y: -keyboardHeight)
            .ignoresSafeArea(.keyboard, edges: .all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let info = notification.userInfo, let height = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                    keyboardHeight = height
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                keyboardHeight = 0
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: keyboardHeight)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $navigateToLogin) {
            LoginView(emailID: $emailID, password: $password, showRegister: $showRegister, isLoggedIn: $navigateToLogin)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .previewDevice("iPhone 13") // Thay đổi thiết bị để xem trước trên các thiết bị khác
            .previewLayout(.sizeThatFits)
    }
}
