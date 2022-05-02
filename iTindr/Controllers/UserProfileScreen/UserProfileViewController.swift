import UIKit
import TagListView

class UserProfileViewController: UIViewController {
    var overlay: UIView? = nil
    var matchOverlay: UIView? = nil
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userTagList: TagListView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDescription: UILabel!

    func initViewData() {
        setupViews()
        userName.text = Store.currentUserProfile!.name
        userDescription.text = Store.currentUserProfile!.aboutMyself

        if let url = URL(string: Store.currentUserProfile!.avatar ?? "") {
            if let data = try? Data(contentsOf: url) {
                userAvatar.image = UIImage(data: data)!
                return
            }
        }

        userAvatar.image = UIImage(named: "ProfilePlaceholder")
        initTagList()
    }

    func setupViews() {
        overlay = Overlay.getOverlay(view: view)
        userAvatar.layer.masksToBounds = true
        userAvatar.layer.cornerRadius = userAvatar.bounds.width / 2
        userTagList.textFont = UIFont.systemFont(ofSize: 20)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor(red: 250/255.0, green: 19/255.0, blue: 171/255.0, alpha: 1.0);
    }

    func initTagList() {
        let topics = Store.currentUserProfile?.topics?.map{$0.title} ?? []

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            tabBarController?.tabBar.isHidden = false
        }
    }
}


