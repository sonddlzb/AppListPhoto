//
//  MediaUseCase.swift
//  Domain
//
//  Created by Đào Đăng Sơn on 21/11/25.
//

import Foundation

public protocol MediaUseCase {
    func fetchPhotos(page: Int,
                     limit: Int,
                     completion: @escaping (Result<[PhotoEntity], Error>) -> Void)
}
