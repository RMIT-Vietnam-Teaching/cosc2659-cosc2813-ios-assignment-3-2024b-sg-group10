

import Foundation
import SwiftUI

struct SafetyTipsScreen: View {
    private let tips: [SafetyTip] = [
        SafetyTip(title: "Stay Alert", description: "Always be aware of your surroundings, especially in unfamiliar areas."),
        SafetyTip(title: "Secure Your Belongings", description: "Keep your personal items secure and avoid displaying valuable items in public."),
        SafetyTip(title: "Emergency Contacts", description: "Keep a list of emergency contacts handy and know how to reach them."),
        SafetyTip(title: "Safe Travel", description: "Plan your route in advance and avoid traveling alone at night if possible."),
        SafetyTip(title: "Report Suspicious Activity", description: "If you see something unusual, report it to the local authorities immediately.")
    ]
    
    var body: some View {
        NavigationView {
            List(tips) { tip in
                NavigationLink(destination: SafetyTipDetailView(tip: tip)) {
                    VStack(alignment: .leading) {
                        Text(tip.title)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(tip.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Safety Tips")
            .navigationBarBackButtonHidden(true)
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SafetyTipDetailView: View {
    var tip: SafetyTip
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(tip.title)
                    .font(.largeTitle)
                    .padding(.top)
                
                Text(tip.description)
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Tip Details")
        .navigationBarBackButtonHidden(true)
    }
}

struct SafetyTipsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SafetyTipsScreen()
    }
}
