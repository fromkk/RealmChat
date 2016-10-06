//
//  Room.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Room: Object {
    dynamic var roomId: String = NSUUID().uuidString
    dynamic var name: String = ""
    let members: List<Member> = List<Member>()
    dynamic var createdAt: NSDate = NSDate()
}

extension Room {
    static func create(name: String) {
        guard let member: Member = Member.currentMember else {
            return
        }

        let realm: Realm = try! Realm()
        let room: Room = Room()
        room.name = name
        room.members.append(member)
        try! realm.write {
            realm.add(room)
        }
    }
}
