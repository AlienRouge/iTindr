import Foundation

class UserActions {
    static func register(email: String, password: String,
                         successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        let params: [String: String] = [
            "email": email,
            "password": password
        ]

        API.registerUser(params: params)
                .validate()
                .responseDecodable(of: TokenData.self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        UserDefaults.standard.set(value.accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(value.refreshToken, forKey: "refreshToken")
                        print(response)
                        successCallback()

                    case .failure(let error):
                        errorCallBack()
                        debugPrint(response)
                    }

                }
    }

    static func login(email: String, password: String,
                      successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        let params: [String: String] = [
            "email": email,
            "password": password
        ]

        API.loginUser(params: params)
                .validate()
                .responseDecodable(of: TokenData.self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        print(value.accessToken)
                        UserDefaults.standard.set(value.accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(value.refreshToken, forKey: "refreshToken")
                        successCallback()

                    case .failure(let error):
                        errorCallBack()
                        debugPrint(response)
                        print(error)
                    }

                }
    }

    static func topics(successCallback: @escaping ([Topic]) -> Void, errorCallBack: @escaping () -> Void) {
        API.getTopics()
                .validate()
                .responseDecodable(of: [Topic].self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        successCallback(value)

                    case .failure(let error):
                        print("Fail!")
                        print(error)
                        errorCallBack()
                    }

                }

    }

    static func profile(successCallback: @escaping (ProfileData) -> Void, errorCallBack: @escaping () -> Void) {
        API.getProfile()
                .validate()
                .responseDecodable(of: ProfileData.self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        successCallback(value)

                    case .failure(let error):
                        print("Fail!")
                        print(error)
                        errorCallBack()
                    }

                }

    }

    static func updateProfile(profileData: ProfileData, successCallback: @escaping (ProfileData) -> Void, errorCallBack: @escaping () -> Void) {
        let topics = profileData.topics?.map {
            $0.id
        }

        let params: [String: Any] = [
            "name": profileData.name,
            "aboutMyself": profileData.aboutMyself ?? "",
            "topics": topics
        ]

        // TODO PATCH

        API.updateProfile(params: params)
                .validate()
                .responseDecodable(of: ProfileData.self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        successCallback(value)

                    case .failure(let error):
                        print("Fail!")
                        print(error)
                        errorCallBack()
                    }

                }
    }

    static func updateProfileImage(image: Data, successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        API.updateProfileAvatar(image: image).validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        debugPrint(response)
                        successCallback()

                    case .failure(let error):
                        print("Fail!")
                        debugPrint(response)
                        errorCallBack()
                    }

                }
    }

    static func deleteProfileImage(successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        API.deleteProfileAvatar()
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        debugPrint(response)
                        successCallback()

                    case .failure(let error):
                        print("Fail!")
                        debugPrint(response)
                        errorCallBack()
                    }

                }
    }

    static func getCurrentUserFlowUsers(successCallback: @escaping ([ProfileData]) -> Void, errorCallBack: @escaping () -> Void) {
        API.getFeed()
                .validate()
                .responseDecodable(of: [ProfileData].self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        successCallback(value)

                    case .failure(let error):
                        print("Fail!")
                        print(error)
                        errorCallBack()
                    }

                }
    }

    static func likeUser(userId: String, successCallback: @escaping (Bool) -> Void, errorCallBack: @escaping () -> Void) {
        API.likeUser(userId: userId)
                .validate()
                .responseDecodable(of: Like.self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        successCallback(value.isMutual)
                        debugPrint(response)

                    case .failure(let error):
                        print("Fail!")
                        print(error)
                        errorCallBack()
                    }

                }
    }

    static func dislikeUser(userId: String, successCallback: @escaping () -> Void, errorCallBack: @escaping () -> Void) {
        API.dislikeUser(userId: userId)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        successCallback()

                    case .failure(let error):
                        print("Fail!")
                        print(error)
                        errorCallBack()
                    }

                }
    }

    static func getUsers(limit: Int, offset: Int, successCallback: @escaping ([ProfileData]) -> Void, errorCallBack: @escaping () -> Void){
        let params: [String: Int] = [
            "limit": limit,
            "offset": offset
        ]

        API.getUsers(params: params)
                .validate()
                .responseDecodable(of: [ProfileData].self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        successCallback(value)
                        debugPrint(response)

                    case .failure(let error):
                        print("Fail!")
                        debugPrint(response)
                        errorCallBack()
                    }
                }
    }

    static func getChats(successCallback: @escaping ([ChatItem]) -> Void, errorCallBack: @escaping () -> Void){
        API.getChats()
                .validate()
                .responseDecodable(of: [ChatItem].self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        successCallback(value)
                        debugPrint(response)

                    case .failure(let error):
                        print("Fail!: \(error)")
                        debugPrint(response)
                        errorCallBack()
                    }
                }
    }

    static func createChat(userId: String, successCallback: @escaping (Chat) -> Void, errorCallBack: @escaping () -> Void){
        let params: [String: String] = [
            "userId": userId,
        ]

        API.createChat(params: params)
                .validate()
                .responseDecodable(of: Chat.self) {
                    response in
                    switch response.result {
                    case .success(let value):
                        successCallback(value)
                        debugPrint(response)

                    case .failure(let error):
                        print("Fail!: \(error)")
                        debugPrint(response)
                        errorCallBack()
                    }
                }
    }
}



