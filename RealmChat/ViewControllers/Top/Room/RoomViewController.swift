//
//  RoomViewController.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class RoomViewController: UIViewController {
    var room: Room!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var messageField: UITextField!
    var messages: Results<Message>!
    var notificationToken: NotificationToken?

    override func loadView() {
        super.loadView()

        self.title = self.room.name

        let realm: Realm = try! Realm()
        let predicate: NSPredicate = NSPredicate(format: "roomId = %@", self.room.roomId)
        self.messages = realm.objects(Message.self).filter(predicate).sorted(byProperty: "createdAt", ascending: true)
        self.notificationToken = self.messages.addNotificationBlock { [weak self] (changes) in
            guard let strongSelf = self else {
                return
            }

            objc_sync_enter(strongSelf)
            switch changes {
            case .initial(_):
                strongSelf.tableView.reloadData()
                strongSelf.scrollToBottom(animated: true)
            case .update(_, let deletions, let insertions, let modifications):
                strongSelf.tableView.beginUpdates()
                strongSelf.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .bottom)
                strongSelf.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .bottom)
                strongSelf.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .bottom)
                strongSelf.tableView.endUpdates()

                strongSelf.scrollToBottom(animated: true)
            case .error(let error):
                print(error)
            }
            objc_sync_exit(strongSelf)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.scrollToBottom(animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        self.notificationToken?.stop()
    }
    
    @IBAction func onSendButtonDidTapped(_ sender: AnyObject) {
        guard let text: String = self.messageField.text else {
            return
        }

        self.messageField.resignFirstResponder()
        self.messageField.text = nil

        let message: Message = Message()
        message.userId = Member.currentMember!.userId
        message.text = text
        message.roomId = self.room.roomId

        let realm: Realm = try! Realm()
        try! realm.write {
            realm.add(message)
        }
    }

    fileprivate func scrollToBottom(animated: Bool) {
        if 0 < self.messages.count {
            let indexPath: IndexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
        }
    }

    @IBAction func onViewDidTapped(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
}

extension RoomViewController {
    func keyboardWillShow(notification: Notification?) {
        if let keyboardFrame: CGRect = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputViewBottom.constant = keyboardFrame.size.height
            UIView.animate(withDuration: 0.33, animations: { [unowned self] in
                self.view.layoutIfNeeded()
            }) { [unowned self] (completion) in
                self.scrollToBottom(animated: true)
            }
        }
    }

    func keyboardWillHide(notification: Notification?) {
        self.inputViewBottom.constant = 0.0
        UIView.animate(withDuration: 0.33, animations: { [unowned self] in
            self.view.layoutIfNeeded()
        })
    }
}

extension RoomViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = MessageCell.reuseCell(with: tableView, indexPath: indexPath)
        let message: Message = self.messages[indexPath.row]
        cell.messageLabel.text = message.text
        if message.userId == Member.currentMember?.userId {
            cell.messageLabel.textAlignment = NSTextAlignment.right
        } else {
            cell.messageLabel.textAlignment = NSTextAlignment.left
        }

        return cell
    }
}

extension RoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension RoomViewController: StoryboardInstantitable {
    static var storyboardName: String {
        return "Top"
    }

    static var viewControllerIdentifier: String {
        return "roomViewController"
    }
}
