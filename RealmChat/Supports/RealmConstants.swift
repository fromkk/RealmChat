//
//  RealmConstants.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

enum RealmConstants {
    private static let host: String = "127.0.0.1"
    private static let databaseName: String = "realmchat"
    private static let port: Int = 9080
    static let authURL: URL = URL(string: "http://\(host):\(port)")!
    static let realmURL: URL = URL(string: "realm://\(host):\(port)/\(databaseName)")!
    static let adminToken: String = "YOUR ADMIN TOKEN HERE"
    static let identity: String = "USER IDENTITY HERE"

    static func setDefaultUser(user: RLMSyncUser) {
        let configuration: Realm.Configuration = Realm.Configuration(syncConfiguration: (user, realmURL))
        Realm.Configuration.defaultConfiguration = configuration
    }
}
