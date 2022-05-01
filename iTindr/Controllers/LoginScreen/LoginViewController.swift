import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailArea: UITextField!
    @IBOutlet weak var passwordArea: UITextField!
    @IBOutlet weak var errorArea: UILabel!
    var overlay: UIView? = nil

    @IBAction func loginBtnAction(_ sender: Any) {
        guard (AuthUtils.isValidEmail(emailArea.text ?? "WrongEmail")) else {
            setErrorMessage(message: "Введите корректный E-Mail")
            return
        }

        guard (passwordArea.text != "") else {
            setErrorMessage(message: "Введите пароль")
            return
        }

        overlay = Overlay.getOverlay(view: view)
        view.addSubview(overlay!)

        UserActions.login(
                email: emailArea.text!,
                password: passwordArea.text!,
                successCallback: {
                    Store.loadAllDataFromServer(successCallback: self.onLoginSuccessHandler, errorCallBack: { })
                },
                errorCallBack: onLoginFailHandler)
    }

    func onLoginSuccessHandler() {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "MainTabBarController")

        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .flipHorizontal

        present(nextVC, animated: true, completion: nil)
    }

    func onLoginFailHandler() {
        overlay?.removeFromSuperview()
        setErrorMessage(message: "Неверный E-Mail или пароль")
    }
    
    func setErrorMessage(message: String){
        errorArea.isHidden = false
        errorArea.text = message
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
