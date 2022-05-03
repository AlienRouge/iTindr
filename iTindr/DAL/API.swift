import Alamofire


let baseUrl = "http://193.233.85.238/itindr/api/mobile"
let registerPrefix = "/v1/auth/register"
let loginPrefix = "/v1/auth/login"
let topicPrefix = "/v1/topic"
let profilePrefix = "/v1/profile"
let profileAvatarPrefix = "/v1/profile/avatar"
let feedPrefix = "/v1/user/feed"
let userPrefix = "/v1/user"
let chatPrefix = "/v1/chat"

let headers: HTTPHeaders = [
    "authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")",
]

struct API {
    static func registerUser(params: [String: String]) -> DataRequest {
        AF.request(baseUrl + registerPrefix,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default)
    }

    static func loginUser(params: [String: String]) -> DataRequest {
        AF.request(baseUrl + loginPrefix,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default)
    }

    static func getTopics() -> DataRequest {
        AF.request(baseUrl + topicPrefix,
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
    }

    static func getProfile() -> DataRequest {
        AF.request(baseUrl + profilePrefix,
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
    }

    static func updateProfile(params: [String: Any]) -> DataRequest {
        AF.request(baseUrl + profilePrefix,
                method: .patch,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: headers)
    }

    static func updateProfileAvatar(image: Data) -> DataRequest {
        let localHeader: HTTPHeaders = [
            "authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")",
            "Accept": "multipart/form-data"
        ]

        return AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image,
                    withName: "avatar",
                    fileName: "avatar.jpeg",
                    mimeType: "image/jpeg")
        },
                to: baseUrl + profileAvatarPrefix,
                method: .post,
                headers: headers)
    }

    static func deleteProfileAvatar() -> DataRequest {
        AF.request(baseUrl + profileAvatarPrefix,
                method: .delete,
                encoding: JSONEncoding.default,
                headers: headers)
    }

    static func getFeed() -> DataRequest {
        AF.request(baseUrl + feedPrefix,
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
    }

    static func likeUser(userId: String) -> DataRequest {
        AF.request(baseUrl + "/v1/user/\(userId)/like",
                method: .post,
                headers: headers)
    }

    static func dislikeUser(userId: String) -> DataRequest {
        AF.request(baseUrl + "/v1/user/\(userId)/dislike",
                method: .post,
                headers: headers)
    }

    static func getUsers(params: [String: Int]) -> DataRequest {
       AF.request(baseUrl + userPrefix,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                headers: headers)
    }

    static func createChat(params: [String: String]) -> DataRequest {
        print(params)
        return AF.request(baseUrl + chatPrefix,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: headers)
    }

    static func getChats() -> DataRequest {
        AF.request(baseUrl + chatPrefix,
                method: .get,
                encoding: URLEncoding.default,
                headers: headers)
    }
}

