import Foundation
import UIKit
import TagListView

class AboutUserViewController: UIViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameArea: UILabel!
    @IBOutlet weak var userTagList: TagListView!
    @IBOutlet weak var userDescriptionArea: UILabel!
    
    func setupViews(){
        userTagList.textFont = UIFont.systemFont(ofSize: 14)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor.white;
    }
    
    func initViewData(){
        if let profile = Store.getCurrentUserProfile(){

            if let url = URL(string: profile.avatar ?? "") {
                if let data = try? Data(contentsOf: url) {
                    userAvatar.image = UIImage(data: data)!
                }
            }
            userNameArea.text = profile.name
            userDescriptionArea.text = profile.aboutMyself
            initTagList(profile: profile)
        }
    }

    func initTagList(profile: ProfileData) {
        userTagList.removeAllTags()
        let topics = profile.topics?.map {
            $0.title
        } ?? []

        for title in topics {
            let tag = userTagList.addTag(title)
            tag.isSelected = true
        }
    }

    override func viewDidLoad() {
        setupViews()
        initViewData()
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            tabBarController?.tabBar.isHidden = false
        }
    }
}
