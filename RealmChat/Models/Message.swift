//
//  Message.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Message: Object {
    dynamic var userId: String = ""
    dynamic var roomId: String = ""
    dynamic var text: String = ""
    dynamic var createdAt: NSDate = NSDate()
}
