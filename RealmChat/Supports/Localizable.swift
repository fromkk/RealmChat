//
//  Localizable.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

protocol Localizable: RawRepresentable {
    var rawValue: String { get }
}

extension Localizable {
    func localize(table: String? = "Localizable", bundle: Bundle = Bundle.main) -> String {
        if nil == table {
            return NSLocalizedString(self.rawValue, comment: "")
        } else {
            return NSLocalizedString(self.rawValue, tableName: table, bundle: bundle, value: "", comment: "")
        }
    }
}
