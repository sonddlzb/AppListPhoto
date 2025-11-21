//
//  PhotoRepository.swift
//  Platform
//
//  Created by Đào Đăng Sơn on 21/11/25.
//

import Foundation
import Domain

struct PhotoRepository: Domain.PhotoRepository {
    func fetchPhotos(page: Int,
                     limit: Int,
                     completion: @escaping (Result<[Domain.PhotoEntity], Error>) -> Void) {
        guard var components = URLComponents(string: NetworkConfig.baseURL) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]

        guard let url = components.url else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.zeroByteResource)))
                return
            }

            do {
                let photos = try JSONDecoder().decode([PhotoEntity].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
