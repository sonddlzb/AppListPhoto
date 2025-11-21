//
//  PhotoUseCase.swift
//  Platform
//
//  Created by Đào Đăng Sơn on 21/11/25.
//

import Foundation
import Domain

struct MediaUseCase: Domain.MediaUseCase {
    let photoRepository: Domain.PhotoRepository

    init(photoRepository: Domain.PhotoRepository) {
        self.photoRepository = photoRepository
    }

    func fetchPhotos(page: Int,
                     limit: Int,
                     completion: @escaping (Result<[Domain.PhotoEntity], Error>) -> Void) {
        photoRepository.fetchPhotos(page: page, limit: limit, completion: completion)
    }

}
