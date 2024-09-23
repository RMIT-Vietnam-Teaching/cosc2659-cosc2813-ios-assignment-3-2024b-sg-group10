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

struct PageIntro: Identifiable, Hashable {
    var id: UUID = .init()
    var introAssetImage: String
    var title: String
    var subTitle: String
}

var pageIntros: [PageIntro] = [
    .init(introAssetImage: "Page 1", title: "Connect With\nCreators Easily", subTitle: "Thank you for choosing us, we can save your lovely time."),
    .init(introAssetImage: "Page 2", title: "Get Inspiration\nFrom Creators", subTitle: "Find your favourite creator and get inspired by them.")
]
