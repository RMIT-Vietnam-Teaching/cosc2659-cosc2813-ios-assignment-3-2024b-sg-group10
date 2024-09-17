import SwiftUI
import UIKit

struct EmergencyContact: Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    var image: UIImage?
}
