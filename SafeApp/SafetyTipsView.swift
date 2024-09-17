import Foundation
import SwiftUI

struct SafetyTipsScreen: View {
    private let tips: [SafetyTip] = [
        SafetyTip(title: "Stay Alert", description: "Always be aware of your surroundings, especially in unfamiliar areas.", detailedDescription: "Staying vigilant means being attentive to the people and environment around you, particularly when you're in new or unfamiliar locations. This includes observing the behavior of individuals nearby, paying attention to unusual activities, and being conscious of any potential hazards. Avoid distractions such as looking at your phone or listening to music with headphones, as these can make you less aware of your surroundings. If you feel uncomfortable or notice anything suspicious, trust your instincts and take appropriate action to ensure your safety. Remember, staying aware can help you anticipate and avoid potential dangers before they become serious"),
        
        SafetyTip(title: "Secure Your Belongings", description: "Keep your personal items secure and avoid displaying valuable items in public.", detailedDescription: "Ensuring the safety of your belongings involves being mindful of where and how you carry your personal items. Use secure bags or pockets with zippers and always keep your possessions close to you. Avoid placing valuable items, such as expensive jewelry, electronics, or large amounts of cash, in easily visible or accessible spots. When in public places, be cautious of pickpockets and opportunistic thieves who may take advantage of distracted individuals. Consider using anti-theft bags or money belts for added security. Additionally, avoid displaying high-value items, like flashy gadgets or designer accessories, as they can attract unwanted attention. By staying vigilant and keeping your belongings secure, you reduce the risk of theft and increase your personal safety."),
        
        SafetyTip(title: "Emergency Contacts", description: "Keep a list of emergency contacts handy and know how to reach them.", detailedDescription: "Having a list of emergency contacts readily available is crucial for quickly accessing help in urgent situations. Ensure that your list includes key contacts such as family members, close friends, medical professionals, and local emergency services. Store this information in multiple accessible locations, such as in your phone, on a printed card in your wallet, or within a secure app designed for emergencies.\n\nIn addition to contact numbers, include relevant details such as medical conditions, allergies, and specific needs of those listed. This information can be invaluable for responders who need to provide immediate assistance. Familiarize yourself with how to reach these contacts, and ensure that they are updated with the correct and current information.\n\nFor added safety, consider storing emergency contact information in a location known to trusted individuals who can access it on your behalf if needed. Regularly review and update this list to account for any changes in contact information or personal circumstances. By being prepared with a comprehensive and easily accessible list, you enhance your ability to quickly respond to emergencies and ensure that help can be reached promptly when needed."),
        
        SafetyTip(title: "Safe Travel", description: "Plan your route in advance and avoid traveling alone at night if possible.", detailedDescription: "Planning your route before you set out helps you stay aware of the journey ahead, including any potential risks or hazards. Utilize navigation apps or maps to determine the safest and most efficient path to your destination. Familiarize yourself with the route, noting any areas that may be less populated or poorly lit. This preparation allows you to avoid unexpected detours and minimizes the risk of getting lost.\n\nIf possible, avoid traveling alone at night. There is often increased risk associated with being out after dark, particularly in unfamiliar or poorly lit areas. If you must travel alone, share your itinerary with a trusted friend or family member, including your expected arrival time and route. Stay in well-lit, populated areas and remain vigilant about your surroundings.\n\nConsider using transportation services or ride-sharing apps that offer safety features such as real-time tracking and emergency buttons. If you’re walking, try to stay in areas with good visibility and avoid shortcuts through isolated areas.\n\nAlways trust your instincts—if something feels off or uncomfortable, seek a safe place and reassess your situation. Being prepared and cautious can help ensure a safer journey and reduce the likelihood of encountering problems on the road."),
        
        SafetyTip(title: "Report Suspicious Activity", description: "If you see something unusual, report it to the local authorities immediately.", detailedDescription: "Being vigilant about your surroundings and noticing anything out of the ordinary can play a crucial role in maintaining community safety. If you observe suspicious behavior, unattended items, or any situation that seems unusual or potentially dangerous, it is important to report it promptly to local authorities.\n\nActing quickly can prevent potential threats from escalating. For example, if you see someone acting suspiciously in a public area, or if you come across a package or bag that appears to be abandoned, do not hesitate to contact the police. Most local police departments have non-emergency numbers or community watch programs where you can report such observations.\n\nProvide as much detail as possible when making a report, including descriptions of individuals, vehicles, and the nature of the suspicious activity. Your observations, no matter how small they may seem, could be vital in helping authorities address potential issues before they develop further.\n\nRemember, reporting unusual activity is a proactive step towards ensuring a safer environment for everyone. It’s better to err on the side of caution and let trained professionals assess the situation.")
    ]
    
    var body: some View {
        NavigationStack {
            List(tips) { tip in
                NavigationLink(destination: SafetyTipDetailView(tip: tip)) {
                    VStack(alignment: .leading) {
                        Text(tip.title)
                            .font(.headline)
                            .fontWeight(.bold)
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
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SafetyTipDetailView: View {
    var tip: SafetyTip
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(tip.description)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                
                Text(tip.detailedDescription)
                    .font(.body)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Tip Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SafetyTipsScreen()
}
