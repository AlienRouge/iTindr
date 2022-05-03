import UIKit
import TagListView

class UserProfileViewController: UIViewController {
    var overlay: UIView? = nil
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userTagList: TagListView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet var matchView: UIView!
    @IBOutlet weak var userDescription: UILabel!

    @IBAction func skipBtnAction(_ sender: Any) {
        showOverlay()
        UserActions.dislikeUser(userId: Store.currentUserProfile!.userId,
                successCallback: {
                    self.hideOverlay()
                }, errorCallBack: {
            self.hideOverlay()
        })
    }

    @IBAction func likeBtnAction(_ sender: Any) {
        let userId = Store.currentUserProfile!.userId
        showOverlay()
        UserActions.likeUser(userId: userId,
                successCallback:
                { isMutual in
                    if true {
                        print("Liked")
                        self.showMatchOverlay()
                    }
                    self.hideOverlay()
                }, errorCallBack: {
            self.hideOverlay()
        })
    }
    @IBAction func sendMessageAction(_ sender: Any) {
        hideMatchOverlay()
        tabBarController!.selectedIndex = 2
    }
    
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
        matchView.frame = view.frame
        navigationController?.view.addSubview(matchView)
        tabBarController?.tabBar.isHidden = true
        userTagList.textFont = UIFont.systemFont(ofSize: 20)
        navigationController?.navigationBar.tintColor = UIColor(red: 250 / 255.0, green: 19 / 255.0, blue: 171 / 255.0, alpha: 1.0);
    }

    func initTagList() {
        let topics = Store.currentUserProfile?.topics?.map {
            $0.title
        } ?? []

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

    func showMatchOverlay() {
        matchView.isHidden = false;
    }

    func hideMatchOverlay() {
        matchView.isHidden = true;
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


