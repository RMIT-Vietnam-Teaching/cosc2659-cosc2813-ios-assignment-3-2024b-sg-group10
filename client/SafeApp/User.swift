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
