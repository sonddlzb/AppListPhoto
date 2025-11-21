//
//  ImageLoader.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()

    private var cache = NSCache<NSURL, UIImage>()
    private var tasks: [UUID: URLSessionDataTask] = [:]

    func load(_ url: URL, completion: @escaping (UIImage?) -> Void) -> UUID {
        if let cached = cache.object(forKey: url as NSURL) {
            completion(cached)
            return UUID()
        }

        let id = UUID()

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            defer { self?.tasks.removeValue(forKey: id) }

            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            self?.cache.setObject(image, forKey: url as NSURL)
            completion(image)
        }

        tasks[id] = task
        task.resume()
        return id
    }

    func cancel(_ id: UUID) {
        tasks[id]?.cancel()
        tasks.removeValue(forKey: id)
    }
}
