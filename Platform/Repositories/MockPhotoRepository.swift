//
//  MockPhotoRepository.swift
//  Platform
//
//  Created by Đào Đăng Sơn on 21/11/25.
//

import Foundation
import Domain

struct MockPhotoRepository: Domain.PhotoRepository {
    func fetchPhotos(page: Int,
                     limit: Int,
                     completion: @escaping (Result<[Domain.PhotoEntity], Error>) -> Void) {
        guard let allPhotos = self.loadMockData() else {
            let error = NSError(domain: "MockError",
                                code: 500,
                                userInfo: [NSLocalizedDescriptionKey: "Cannot load or parse mock data"])
            DispatchQueue.main.async { completion(.failure(error)) }
            return
        }

        let startIndex = (page - 1) * limit
        let endIndex = min(startIndex + limit, allPhotos.count)

        guard startIndex < allPhotos.count else {
            DispatchQueue.main.async { completion(.success([])) }
            return
        }

        let photosForPage = Array(allPhotos[startIndex..<endIndex])
        DispatchQueue.main.async {
            completion(.success(photosForPage))
        }
    }
}

extension MockPhotoRepository {
    private func loadMockData() -> [PhotoEntity]? {
        guard let url = Bundle.main.url(forResource: "mock_photos", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }

        do {
            let photos = try JSONDecoder().decode([PhotoEntity].self, from: data)
            return photos
        } catch {
            print("Lỗi parse JSON Mock: \(error)")
            return nil
        }
    }
}
