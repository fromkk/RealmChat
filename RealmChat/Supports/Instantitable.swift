//
//  Instantitable.swift
//  RealmChat
//
//  Created by Kazuya Ueoka on 2016/10/05.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

protocol StoryboardInstantitable: class {
    static var storyboardName: String { get }
    static var viewControllerIdentifier: String { get }
}

extension StoryboardInstantitable {
    static func instantitate() -> Self {
        guard let result: Self = UIStoryboard(name: Self.storyboardName, bundle: Bundle(for: Self.self)).instantiateViewController(withIdentifier: Self.viewControllerIdentifier) as? Self else {
            fatalError("instantitate failed")
        }

        return result
    }
}

protocol XibInstantitable: class {
    static var nibName: String { get }
}

extension XibInstantitable {
    static func instantitate(with owner: Any? = nil) -> Self {
        guard let result: Self = UINib(nibName: Self.nibName, bundle: Bundle(for: Self.self)).instantiate(withOwner: owner, options: nil).first as? Self else {
            fatalError("instantitate failed")
        }

        return result
    }
}
