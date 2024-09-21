import SwiftUI
import Combine

struct UpdateUserView: View {
    var token: String
    @State private var userInfo: [String: Any]? = nil

    var body: some View {
        VStack {
            if let userInfo = userInfo {
                Text("Username: \(userInfo["username"] as? String ?? "N/A")")
                Text("Email: \(userInfo["email"] as? String ?? "N/A")")
            } else {
                Text("Loading user info...")
            }
        }
        .onAppear {
            userInfo = decode(jwtToken: token)
        }
    }
}

func decode(jwtToken jwt: String) -> [String: Any]? {
    let segments = jwt.split(separator: ".")
    guard segments.count == 3 else { return nil }
    let base64String = String(segments[1])
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    let requiredLength = (4 * ceil(Double(base64String.count) / 4.0))
    let paddingLength = requiredLength - Double(base64String.count)
    let paddedBase64String = base64String.padding(toLength: base64String.count + Int(paddingLength), withPad: "=", startingAt: 0)
    
    guard let decodedData = Data(base64Encoded: paddedBase64String),
          let json = try? JSONSerialization.jsonObject(with: decodedData, options: []),
          let payload = json as? [String: Any] else { return nil }
    
    return payload
}

