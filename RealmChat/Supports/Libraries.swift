//
//  Libraries.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

func showErrorAlert(message: String, for viewController: UIViewController, callback: (() -> Void)?) {
    let alertController: UIAlertController = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: UIAlertControllerStyle.alert)
    let actionOK: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
        callback?()
    }
    alertController.addAction(actionOK)
    viewController.present(alertController, animated: true, completion: nil)
}
