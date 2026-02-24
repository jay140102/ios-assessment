import Foundation

struct NavigationResponse: Codable {
    let result: NavigationResult
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case result
        case sessionId = "session_id"
    }
}

struct NavigationResult: Codable {
    let title: String
    let userPhoto: String
    let coverPhoto: String
    let walletAmount: String
    let walletUrl: String
    let menus: [MenuItem]
    let notificationCount: Int
    let friendReqCount: Int
    let messageCount: Int
    let loggedinUserId: Int

    enum CodingKeys: String, CodingKey {
        case title
        case userPhoto = "user_photo"
        case coverPhoto = "cover_photo"
        case walletAmount = "wallet_amount"
        case walletUrl = "wallet_url"
        case menus
        case notificationCount = "notification_count"
        case friendReqCount = "friend_req_count"
        case messageCount = "message_count"
        case loggedinUserId = "loggedin_user_id"
    }
}

struct MenuItem: Codable, Identifiable {
    var id: String { label + url }
    let type: Int
    let module: String?
    let label: String
    let icon: String
    let url: String
    let `class`: String

    enum CodingKeys: String, CodingKey {
        case type
        case module
        case label
        case icon
        case url
        case `class` = "class"
    }
}
