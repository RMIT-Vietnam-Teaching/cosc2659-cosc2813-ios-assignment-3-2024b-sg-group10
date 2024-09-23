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

struct IntroView: View {
    @Binding var intro: PageIntro
    var size: CGSize
    var onCompletion: () -> Void // Closure để gọi hành động khi trang cuối cùng

    var body: some View {
        VStack {
            TabView(selection: $intro) {
                ForEach(pageIntros) { page in
                    IntroPageView(page: page, size: size)
                        .tag(page)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onChange(of: intro) { newValue in
                if newValue == pageIntros.last {
                    // Khi đến trang cuối cùng, thực hiện hành động chuyển tiếp
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onCompletion()
                    }
                }
            }
        }
    }
}

struct IntroPageView: View {
    var page: PageIntro
    var size: CGSize

    var body: some View {
        VStack {
            Image(page.introAssetImage)
                .resizable()
                .scaledToFit()
                .frame(width: size.width * 0.8, height: size.height * 0.5)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.subTitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
