import UIKit
import TagListView

class FlowViewController: UIViewController {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userTagList: TagListView!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var matchOverlay: UIView!
    var overlay: UIView? = nil
    var profile: ProfileData? = nil
    
    @IBAction func likeBtnAction(_ sender: Any) {
        let userId = profile?.userId ?? ""
        showOverlay()
        UserActions.likeUser(userId: userId,
                successCallback:
                { isMutual in
                    print(isMutual)
                    if true {
                        self.showMatchOverlay()
                    } else {
                        self.initViewData()
                    }
                    self.hideOverlay()
                }, errorCallBack: {
            self.hideOverlay()
        })
    }

    @IBAction func skipBtnAction(_ sender: Any) {
        let userId = profile?.userId ?? ""
        showOverlay()
        UserActions.dislikeUser(userId: userId,
                successCallback: {
                    self.hideOverlay()
                    self.initViewData()
                }, errorCallBack: {
            self.hideOverlay()
        })
    }
    @IBAction func sendMessageBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "ChatPage")

        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .flipHorizontal

        self.initViewData()
        hideMatchOverlay()
        tabBarController!.selectedIndex = 2
    }
    
    func initViewData() {
        profile = Store.flow.getUser()

        if profile == nil {
            onProfileNilHandler()
        } else {
            onGetProfileHandler()
        }
    }

    func onGetProfileHandler() {
        userName.text = profile!.name
        userDescription.text = profile!.aboutMyself
        likeBtn.isHidden = false
        skipBtn.isHidden = false
        initTagList()

        if let url = URL(string: profile?.avatar ?? "") {
            if let data = try? Data(contentsOf: url) {
                userAvatar.image = UIImage(data: data)!
                return
            }
        }
        userAvatar.image = UIImage(named: "ProfilePlaceholder")
    }

    func onProfileNilHandler() {
        userTagList.removeAllTags()
        userAvatar.image = nil
        userName.text = "Пользователи закончились!"
        userDescription.text = "Приходите позднее ;)"
        likeBtn.isHidden = true
        skipBtn.isHidden = true
    }

    func showNextProfile() {
        initViewData()
    }

    func initTagList() {
        userTagList.removeAllTags()
        let topics = profile?.topics?.map {
            $0.title
        } ?? []

        for title in topics {
            let tag = userTagList.addTag(title)
            tag.isSelected = true
        }
    }

    func setupViews() {
        overlay = Overlay.getOverlay(view: view)
        userAvatar.layer.masksToBounds = true
        userAvatar.layer.cornerRadius = userAvatar.bounds.width / 2
        matchOverlay.frame = view.frame
        tabBarController?.view.addSubview(matchOverlay!)
        userTagList.textFont = UIFont.systemFont(ofSize: 15)
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
        matchOverlay.isHidden = false;
    }
    
    func hideMatchOverlay() {
        matchOverlay.isHidden = true;
    }

    override func viewDidLoad() {
        setupViews()
        initViewData()
        super.viewDidLoad()
    }

}
