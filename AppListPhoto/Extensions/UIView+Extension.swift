//
//  UIView+Extension.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//

import UIKit

extension UIView {
    func showSkeleton() {
        let light = UIColor(white: 0.85, alpha: 1).cgColor
        let dark  = UIColor(white: 0.75, alpha: 1).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1, y: 0.5)
        gradient.locations  = [0, 0.5, 1]
        gradient.frame = self.bounds
        gradient.name = "skeletonLayer"

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.2
        animation.repeatCount = .infinity

        gradient.add(animation, forKey: "shimmer")
        self.layer.addSublayer(gradient)
    }

    func hideSkeleton() {
        layer.sublayers?.removeAll(where: { $0.name == "skeletonLayer" })
    }
}
