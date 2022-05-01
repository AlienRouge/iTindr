import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailArea: UITextField!
    @IBOutlet weak var passwordArea: UITextField!
    @IBOutlet weak var passwordRepeatArea: UITextField!
    var overlay: UIView? = nil


    @IBAction func registerBtnAction(_ sender: Any) {
        guard (emailArea.text != "") else {
            print("EmptyEmail")
            return
        }

        guard (AuthUtils.isValidEmail(emailArea.text ?? "WrongEmail")) else {
            print("WrongEmail")
            return
        }

        guard (passwordArea.text != "") else {
            print("EmptyPass")
            return
        }

        guard (passwordRepeatArea.text != "") else {
            print("EmptyPassRepeat")
            return
        }

        guard (passwordRepeatArea.text == passwordArea.text) else {
            print("PassIncorrect")
            return
        }

        showOverlay()

        UserActions.register(
                email: emailArea.text!,
                password: passwordArea.text!,
                successCallback: onRegisterSuccessHandler,
                errorCallBack: onRegisterFailHandler
        )
    }


    func onRegisterSuccessHandler() {
        Store.loadProfileAndTopicsDataFromServer(successCallback: {
            let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "CreateProfile")

            nextVC.modalPresentationStyle = .fullScreen
            nextVC.modalTransitionStyle = .flipHorizontal
            self.present(nextVC, animated: true, completion: nil)
        }, errorCallBack: {
            print("Server error!")
        })
    }

    func onRegisterFailHandler() {
        hideOverlay()
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
        overlay = Overlay.getOverlay(view: view)
        // Do any additional setup after loading the view.
    }
}
