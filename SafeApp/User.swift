import Foundation

struct User: Identifiable, Codable {
    var id: String? // changed to var
    var email: String // changed to var
    var role: String // changed to var
    var avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case role
        case avatar
    }
}
