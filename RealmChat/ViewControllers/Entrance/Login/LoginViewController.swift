//
//  LoginViewController.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    enum LoginError: Error {
        case emailOrPasswordEmpty
        case loginFailed
        func message() -> String {
            switch self {
            case .emailOrPasswordEmpty:
                return NSLocalizedString("error.emailOrPasswordEmpty", comment: "")
            case .loginFailed:
                return NSLocalizedString("error.loginFailed", comment: "")
            }
        }
    }

    private enum Localization: String, Localizable {
        case title = "login"
    }

    override func loadView() {
        super.loadView()

        self.title = Localization.title.localize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.view.endEditing(true)
    }

    @IBAction func onLoginButtonDidTapped(_ sender: AnyObject) {
        guard let email: String = self.email.text, 0 < email.characters.count, let password: String = self.password.text, 0 < password.characters.count else {
            showErrorAlert(message: LoginError.emailOrPasswordEmpty.message(), for: self, callback: nil)
            return
        }

        guard let _ = Member.login(email: email, password: password) else {
            showErrorAlert(message: LoginError.loginFailed.message(), for: self, callback: nil)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1000)) {
            (UIApplication.shared.delegate as? AppDelegate)?.controlRootViewController()
        }
    }
}
