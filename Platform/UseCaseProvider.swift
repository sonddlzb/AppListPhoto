//
//  UseCaseProvider.swift
//  Platform
//
//  Created by Đào Đăng Sơn on 21/11/25.
//

import Foundation
import Domain

public struct UseCaseProvider {
    public static func makeMediaUseCase() -> Domain.MediaUseCase {
        let photoRepository: Domain.PhotoRepository
        // if use mock scheme or UITesting, inject mock repository
        if AppConfiguration.shared.buildConfiguration == .mock {
            photoRepository = MockPhotoRepository()
        } else {
            photoRepository = PhotoRepository()
        }

        return MediaUseCase(photoRepository: photoRepository)
    }
}
