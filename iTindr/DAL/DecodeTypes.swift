import Foundation

struct TokenData: Decodable {
    let accessToken: String
    let accessTokenExpiredAt: String
    let refreshToken: String
    let refreshTokenExpiredAt: String

    enum CodingKeys: String, CodingKey {
        case accessToken
        case accessTokenExpiredAt
        case refreshToken
        case refreshTokenExpiredAt
    }
}

struct ProfileData: Decodable {
    let userId: String
    let name: String
    let aboutMyself: String?
    let avatar: String?
    let topics: [Topic]?

    enum CodingKeys: String, CodingKey {
        case userId
        case name
        case aboutMyself
        case avatar
        case topics
    }
}

struct Topic: Decodable {
    let id: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
}

struct Like: Decodable {
    let isMutual: Bool

    enum CodingKeys: String, CodingKey {
        case isMutual
    }
}



