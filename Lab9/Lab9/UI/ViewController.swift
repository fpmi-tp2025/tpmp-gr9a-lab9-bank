import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Loginspace: UIView!
    @IBOutlet weak var Singup: UIView!
    @IBOutlet weak var Segmentcontrol: UISegmentedControl!

    // Регистрация
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Login: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Checkingpassword: UITextField!
    @IBOutlet weak var Personal: UISwitch!

    // Вход
    @IBOutlet weak var Loginwithemail: UITextField!
    @IBOutlet weak var Vvhod: UITextField!

    override func viewDidLoad() {
           super.viewDidLoad()
           setupInitialState()
           
           if UserDefaults.standard.bool(forKey: "isLoggedIn") {
               navigateToMainScreen()
           }
       }

       private func setupInitialState() {
           Loginspace.isHidden = true
           configureSecureTextFields()
           configurePlaceholders()
       }

       private func configureSecureTextFields() {
           Password.isSecureTextEntry = true
           Checkingpassword.isSecureTextEntry = true
           Vvhod.isSecureTextEntry = true
       }

       private func configurePlaceholders() {
           Login.placeholder = "Логин"
           Email.placeholder = "E-mail"
           Password.placeholder = "Пароль"
           Checkingpassword.placeholder = "Повторите пароль"
           Loginwithemail.placeholder = "Логин или E-mail"
           Vvhod.placeholder = "Пароль"
       }

       @IBAction func SegmentcontrolChanged(_ sender: UISegmentedControl) {
           UIView.animate(withDuration: 0.3) {
               self.Loginspace.isHidden = sender.selectedSegmentIndex != 1
               self.Singup.isHidden = sender.selectedSegmentIndex != 0
           }
       }

       @IBAction func buttomSingIn(_ sender: UIButton) {
           guard
               let loginEmail = Loginwithemail.text, !loginEmail.isEmpty,
               let password = Vvhod.text, !password.isEmpty
           else {
               showAlert(title: "Ошибка", message: "Заполните все поля")
               return
           }

           checkCredentials(login: loginEmail, password: password)
       }

       @IBAction func buttomSingUp(_ sender: UIButton) {
           guard
               let loginText = Login.text, !loginText.isEmpty,
               let emailText = Email.text, !emailText.isEmpty,
               let passwordText = Password.text, !passwordText.isEmpty,
               let checkingPasswordText = Checkingpassword.text, !checkingPasswordText.isEmpty,
               passwordText == checkingPasswordText,
               Personal.isOn
           else {
               showAlert(title: "Ошибка", message: "Проверьте:\n- Все поля заполнены\n- Пароли совпадают\n- Согласие с правилами")
               return
           }

           saveUserData(login: loginText, email: emailText, password: passwordText)     }

       private func checkCredentials(login: String, password: String) {
           guard let user = UserData.loadFromPlist() else {
               showAlert(title: "Ошибка", message: "Пользователь не найден")
               return
           }

           if (login == user.login || login == user.email), password == user.password {
               UserDefaults.standard.set(true, forKey: "isLoggedIn")
                navigateToMainScreen()
           } else {
               showAlert(title: "Ошибка", message: "Неверные данные")
           }
           print(" Введено: login=\(login), password=\(password)")
           print(" В Plist: login=\(user.login), email=\(user.email), password=\(user.password)")
       }

    private func navigateToMainScreen() {
        let mainMenuVC = MainMenuViewController()
        let navController = UINavigationController(rootViewController: mainMenuVC)
        view.window?.rootViewController = navController
        view.window?.makeKeyAndVisible()
    }

       private func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }

    private func saveUserData(login: String, email: String, password: String) {
        let user = UserData(login: login, email: email, password: password, bankAccounts: [])
        user.saveToPlist()

        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        navigateToMainScreen()

        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("User.plist").path {
            print("Файл должен быть здесь: \(path)")
        }
        else{print ("Nothing")}

    }
    func addAccountToUser(account: BankAccount) {
        if var user = UserData.loadFromPlist() {
            user.bankAccounts.append(account)
            user.saveToPlist()
        }
    }
}
