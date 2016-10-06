//
//  RoomCell.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {
    @IBOutlet weak var roomNameLabel: UILabel!
}

extension RoomCell: ReusableTableViewCell {
    static var cellIdentifier: String {
        return "roomCell"
    }
}
