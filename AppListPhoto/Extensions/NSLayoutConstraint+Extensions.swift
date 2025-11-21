//
//  NSLayoutConstraint+Extensions.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//

import UIKit

extension NSLayoutConstraint {
    func setMultiplier(to multiplier: CGFloat) -> NSLayoutConstraint {
            NSLayoutConstraint.deactivate([self])

            let newConstraint = NSLayoutConstraint(
                item: firstItem as Any,
                attribute: firstAttribute,
                relatedBy: relation,
                toItem: secondItem,
                attribute: secondAttribute,
                multiplier: multiplier, // new value
                constant: constant
            )

            newConstraint.priority = priority
            newConstraint.identifier = self.identifier

            NSLayoutConstraint.activate([newConstraint])
            return newConstraint
        }
}
