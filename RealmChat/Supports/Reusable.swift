//
//  Reusable.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

protocol ReusableCell: class {
    static var cellIdentifier: String { get }
}

protocol ReusableTableViewCell: ReusableCell {}
protocol ReusableCollectionViewCell: ReusableCell {}

extension ReusableTableViewCell {
    static func reuseCell(with tableView: UITableView, indexPath: IndexPath) -> Self {
        guard let cell: Self = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath) as? Self else {
            fatalError("cell initialize failed")
        }
        return cell
    }
}

extension ReusableCollectionViewCell {
    static func reuseCell(with collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        guard let cell: Self = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellIdentifier, for: indexPath) as? Self else {
            fatalError("cell initialize failed")
        }
        return cell
    }
}
