//
//  Array+Extensions.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//

import Foundation

public extension Array {
    subscript (safe index: Int) -> Element? {
        get {
            return (0 <= index && index < count) ? self[index] : nil
        }

        set (value) {
            if value == nil {
                return
            }

            if !(count > index) {
                NSLog("WARN: index:\(index) is out of range, so ignored. (array:\(self))")
                return
            }

            self[index] = value!
        }
    }
}
