//
//  PhotoEntity.swift
//  Platform
//
//  Created by Đào Đăng Sơn on 21/11/25.
//

import Foundation
import Domain

struct PhotoEntity: Domain.PhotoEntity {
    var id: String?
    var author: String?
    var width: Int?
    var height: Int?
    var url: String?
    var downloadUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadUrl = "download_url"
    }
}
