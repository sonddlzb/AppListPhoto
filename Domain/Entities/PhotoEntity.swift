//
//  PhotoEntity.swift
//  Domain
//
//  Created by Đào Đăng Sơn on 21/11/25.
//

import Foundation

public protocol PhotoEntity: Codable {
    var id: String? { get }
    var author: String? { get }
    var width: Int? { get }
    var height: Int? { get }
    var url: String? { get }
    var downloadUrl: String? { get }
}
