import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailArea: UITextField!
    @IBOutlet weak var passwordArea: UITextField!
    @IBOutlet weak var passwordRepeatArea: UITextField!
    @IBOutlet weak var errorArea: UILabel!
    var overlay: UIView? = nil


    @IBAction func registerBtnAction(_ sender: Any) {
        guard (emailArea.text != "") else {
            setErrorMessage(message: "Введите E-Mail")
            return
        }

        guard (AuthUtils.isValidEmail(emailArea.text ?? "WrongEmail")) else {
            setErrorMessage(message: "Введите корректный E-Mail")
            return
        }

        guard (passwordArea.text != "") else {
            setErrorMessage(message: "Введите пароль")
            return
        }

        guard (passwordArea.text?.count ?? 0 < 6) else {
            setErrorMessage(message: "Слишком короткий пароль")
            return
        }

        guard (passwordRepeatArea.text != "") else {
            setErrorMessage(message: "Повторите пароль")
            return
        }

        guard (passwordRepeatArea.text == passwordArea.text) else {
            setErrorMessage(message: "Пароли не совпадают")
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
    
    func setErrorMessage(message: String){
        errorArea.isHidden = false
        errorArea.text = message
    }

    func onRegisterFailHandler() {
        hideOverlay()
        setErrorMessage(message: "Регистрация не удалась")
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
