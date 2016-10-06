//
//  Member.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import HashKit

class Member: Object {
    enum Status: Int {
        case offline = 0
        case online
    }
    enum Constants {
        static let tokenKey: String = "me.fromkk.RealmChat.Member.token"
    }

    dynamic var userId: String = UUID().uuidString
    dynamic var email: String = ""
    dynamic var password: String = ""
    dynamic var token: String = UUID().uuidString
    dynamic var status: Int = Status.offline.rawValue
}

extension Member {
    enum RegistrationError: Error {
        case already
    }
    static func registration(email: String, password: String) throws {
        let realm: Realm = try! Realm()
        let predicate: NSPredicate = NSPredicate(format: "email = %@", email)
        guard 0 == realm.objects(Member.self).filter(predicate).count else {
            throw RegistrationError.already
        }

        let member: Member = Member()
        member.email = email
        member.password = password.hmac(algorithm: HashableType.sha256, key: "RealmChat")!
        member.status = Status.online.rawValue
        try! realm.write {
            realm.add(member)
        }

        UserDefaults.standard.set(member.token, forKey: Constants.tokenKey)
        UserDefaults.standard.synchronize()
    }

    static func login(email: String, password: String) -> Member? {
        let realm: Realm = try! Realm()
        let predicate: NSPredicate = NSPredicate(format: "email = %@ AND password = %@", email, password.hmac(algorithm: HashableType.sha256, key: "RealmChat")!)
        let member: Member? = realm.objects(Member.self).filter(predicate).first
        if let member = member {
            UserDefaults.standard.set(member.token, forKey: Constants.tokenKey)
            UserDefaults.standard.synchronize()
        }
        return member
    }

    static var currentMember: Member? {
        guard let token: String = UserDefaults.standard.string(forKey: Constants.tokenKey) else {
            return nil
        }

        let realm: Realm = try! Realm()
        let predicate: NSPredicate = NSPredicate(format: "token = %@", token)
        return realm.objects(Member.self).filter(predicate).first
    }

    func offline() {
        let realm: Realm = try! Realm()
        try! realm.write {
            self.status = Status.offline.rawValue
        }
    }

    func online() {
        let realm: Realm = try! Realm()
        try! realm.write {
            self.status = Status.online.rawValue
        }
    }
}
