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
