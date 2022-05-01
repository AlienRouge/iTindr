import UIKit
import TagListView

class ProfileViewController: UIViewController {
    var overlay: UIView? = nil
    var matchOverlay: UIView? = nil
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userTagList: TagListView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDescription: UILabel!

    func initViewData() {
        setupViews()
        userAvatar.image = Store.user.avatarImage
        userName.text = Store.user.name
        userDescription.text = Store.user.aboutMyself
        initTagList()
    }

    func setupViews() {
        overlay = Overlay.getOverlay(view: view)

        userAvatar.layer.masksToBounds = true
        userAvatar.layer.cornerRadius = userAvatar.bounds.width / 2
        userTagList.textFont = UIFont.systemFont(ofSize: 20)


    }

    func initTagList() {
        let topics = Store.user.getTopicTitles()

        for title in topics {
            let tag = userTagList.addTag(title)
            tag.isSelected = true
        }
    }

    func showOverlay() {
        if let controller = tabBarController {
            controller.view.addSubview(overlay!)
        } else {
            view.addSubview(overlay!)
        }
    }

    func hideOverlay() {
        overlay?.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewData()
    }
}


