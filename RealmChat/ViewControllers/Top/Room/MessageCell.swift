//
//  MessageCell.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/06.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}

extension MessageCell: ReusableTableViewCell {
    static var cellIdentifier: String {
        return "messageCell"
    }
}
