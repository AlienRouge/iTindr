import Foundation
import UIKit

struct User {
    var userId: String = ""
    var name: String = ""
    var aboutMyself: String? = nil
    var avatar: String? = nil
    var topics: [Topic]? = nil
    var avatarImage: UIImage?
    var imagePlaceholder: Bool = true

    mutating func setData(userProfile: ProfileData) {
        userId = userProfile.userId
        name = userProfile.name
        aboutMyself = userProfile.aboutMyself
        avatar = userProfile.avatar
        topics = userProfile.topics

        if let url = URL(string: avatar ?? "") {
            if let data = try? Data(contentsOf: url) {
                avatarImage = UIImage(data: data)!
                imagePlaceholder = false
                return
            }
        }

        deleteProfileImage()
    }

    mutating func deleteProfileImage() {
        imagePlaceholder = true
        avatarImage = UIImage(named: "ProfilePlaceholder")
    }

    mutating func setProfileImage(image: UIImage) {
        imagePlaceholder = false
        avatarImage = image
    }

    func getTopicTitles() -> [String] {
        topics?.map {
            $0.title
        } ?? []
    }
}
