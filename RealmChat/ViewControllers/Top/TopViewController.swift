//
//  TopViewController.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class TopViewController: UITableViewController {
    fileprivate enum Localizations: String, Localizable {
        case title = "rooms"
        case createRoom = "createRoom"
    }
    fileprivate enum TopError: Error {
        case roomNameEmpty
        func message() -> String {
            switch self {
            case .roomNameEmpty:
                return NSLocalizedString("error.roomNameisEmpty", comment: "")
            }
        }
    }

    lazy var addButton: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.onAddButtonDidTapped(sender:)))
        return result
    }()
    var roomNameTextField: UITextField?
    var rooms: Results<Room>!
    var notificationToken: NotificationToken?

    override func loadView() {
        super.loadView()

        self.title = Localizations.title.localize()
        self.navigationItem.rightBarButtonItem = self.addButton

        let realm: Realm = try! Realm()
        self.rooms = realm.objects(Room.self).sorted(byProperty: "createdAt", ascending: false)
        self.notificationToken = self.rooms.addNotificationBlock { [weak self] (changes) in
            switch changes {
            case .initial(_):
                self?.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        }
    }

    deinit {
        self.notificationToken?.stop()
    }

    func onAddButtonDidTapped(sender: AnyObject) {
        let alert: UIAlertController = UIAlertController(title: Localizations.createRoom.localize(), message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { [unowned self] (textField: UITextField) in
            self.roomNameTextField = textField
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [unowned self] (action: UIAlertAction) in
            guard let roomName = self.roomNameTextField?.text, 0 < roomName.characters.count else {
                showErrorAlert(message: TopError.roomNameEmpty.message(), for: self, callback: nil)
                return
            }

            Room.create(name: roomName)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension TopViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RoomCell = RoomCell.reuseCell(with: tableView, indexPath: indexPath)
        let room: Room = self.rooms[indexPath.row]
        cell.roomNameLabel.text = room.name
        return cell
    }
}

extension TopViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roomViewController: RoomViewController = RoomViewController.instantitate()
        roomViewController.room = self.rooms[indexPath.row]
        self.navigationController?.pushViewController(roomViewController, animated: true)
    }
    
    @objc(tableView:canFocusRowAtIndexPath:)
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        guard let currentMember: Member = Member.currentMember else {
            return false
        }
        
        let room: Room = self.rooms[indexPath.row]
        return room.author.userId == currentMember.userId
    }
    
    @objc(tableView:canEditRowAtIndexPath:)
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let currentMember: Member = Member.currentMember else {
            return false
        }
        
        let room: Room = self.rooms[indexPath.row]
        return room.author.userId == currentMember.userId
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let realm: Realm = try! Realm()
        
        switch editingStyle {
        case UITableViewCellEditingStyle.delete:
            try! realm.write {
                realm.delete(self.rooms[indexPath.row])
            }
        default:
            break
        }
    }
}

