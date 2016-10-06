//
//  RegisterViewController.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class RegisterViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    enum RegistrationError: Error {
        case emailOrPasswordEmpty
        case registrationFailed
        func message() -> String {
            switch self {
            case .emailOrPasswordEmpty:
                return NSLocalizedString("error.emailOrPasswordEmpty", comment: "")
            case .registrationFailed:
                return NSLocalizedString("error.registrationFailed", comment: "")
            }
        }
    }

    private enum Localization: String, Localizable {
        case title = "registration"
    }

    override func loadView() {
        super.loadView()

        self.title = Localization.title.localize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.view.endEditing(true)
    }
    
    @IBAction func onRegisterButtonDidTapped(_ sender: AnyObject) {
        guard let email: String = self.email.text, 0 < email.characters.count, let password: String = self.password.text, 0 < password.characters.count else {
            showErrorAlert(message: RegistrationError.emailOrPasswordEmpty.message(), for: self, callback: nil)
            return
        }

        do {
            try Member.registration(email: email, password: password)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1000)) {
                (UIApplication.shared.delegate as? AppDelegate)?.controlRootViewController()
            }
        } catch Member.RegistrationError.already {
            showErrorAlert(message: RegistrationError.registrationFailed.message(), for: self, callback: nil)
        } catch let error {
            showErrorAlert(message: error.localizedDescription, for: self, callback: nil)
        }
    }
}
