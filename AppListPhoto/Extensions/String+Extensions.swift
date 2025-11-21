//
//  String+Extensions.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//

import Foundation

extension String {
    var normalized: String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
}
