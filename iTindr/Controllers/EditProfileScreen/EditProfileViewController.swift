import UIKit
import TagListView

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TagListViewDelegate, UITextViewDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameArea: UITextField!
    @IBOutlet weak var descriptionArea: UITextView!

    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var setProfileImageBtn: UIButton!
    var overlay: UIView? = nil
    var selectedTopics: [Topic] = []

    @IBAction func setProfileImageBtn(_ sender: Any) {
        if Store.user.imagePlaceholder {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            showOverlay()

            UserActions.deleteProfileImage(
                    successCallback: {
                        Store.user.deleteProfileImage()
                        self.profileImage.image = Store.user.avatarImage
                        self.setProfileImageBtn.titleLabel?.text = "Выбрать фото"
                        self.hideOverlay()

                    }, errorCallBack: {
                self.hideOverlay()
            })
        }
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        showOverlay()

        UserActions.updateProfileImage(
                image: image.jpegData(compressionQuality: 0.5)!,
                successCallback: {
                    Store.user.setProfileImage(image: image)
                    self.profileImage.image = Store.user.avatarImage
                    self.setProfileImageBtn.titleLabel?.text = "Удалить фото"
                    self.hideOverlay()

                },
                errorCallBack: {
                    self.hideOverlay()
                })

        dismiss(animated: true)
    }


    @IBAction func saveBtn(_ sender: Any) {
        let viewData = getViewData()
        showOverlay()

        UserActions.updateProfile(
                profileData: viewData,
                successCallback: { (newProfile: ProfileData) in
                    Store.user.setData(userProfile: newProfile)
                    print(newProfile)

                    Store.loadFlowDataFromServer(successCallback: {
                        print("Flow")
                        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
                        let nextVC = storyboard.instantiateViewController(identifier: "MainTabBarController")

                        nextVC.modalPresentationStyle = .fullScreen
                        nextVC.modalTransitionStyle = .flipHorizontal

                        self.present(nextVC, animated: true, completion: nil)
                    }, errorCallBack: { self.hideOverlay() })
                },
                errorCallBack: {
                    self.hideOverlay()
                })
    }

    func initView() {
        setupView()
        nameArea.text = Store.user.name
        descriptionArea.text = Store.user.aboutMyself
        if descriptionArea.text.isEmpty {
            descriptionArea.text = "О себе"
            descriptionArea.textColor = UIColor.lightGray
        }

        profileImage.image = Store.user.avatarImage
        if Store.user.imagePlaceholder {
            setProfileImageBtn.titleLabel?.text = "Выбрать фото"
        } else {
            setProfileImageBtn.titleLabel?.text = "Удалить фото"
        }

        initTagList()

    }

    func setupView() {
        overlay = Overlay.getOverlay(view: view)
        tagList.delegate = self
        descriptionArea.delegate = self
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        tagList.textFont = UIFont.systemFont(ofSize: 22)
    }

    func getViewData() -> ProfileData {
        let description: String?
        if descriptionArea.text == "О себе" {
            description = nil
        } else {
            description = descriptionArea.text
        }

        return ProfileData(
                userId: Store.user.userId,
                name: nameArea.text ?? "",
                aboutMyself: description,
                avatar: nil,
                topics: selectedTopics)
    }

    func initTagList() {
        selectedTopics = Store.user.topics ?? []
        for topic in Store.topics.list {
            tagList.addTag(topic.title)
        }
        highlightProfileTags()
    }

    func highlightProfileTags() {
        for topic in selectedTopics {
            for tag in tagList.tagViews {
                if topic.title == tag.currentTitle {
                    tag.isSelected = true
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "О себе"
            textView.textColor = UIColor.lightGray
        }
    }

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected = !tagView.isSelected
        let selTopic = Store.topics.list.first(where: { $0.title == title })!

        if tagView.isSelected {
            selectedTopics.append(selTopic)
        } else {
            selectedTopics = selectedTopics.filter {
                $0.title != selTopic.title
            }
        }
    }
}


