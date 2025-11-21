//
//  PhotoListPresenter.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//

import Domain
import Platform
import Foundation

protocol PhotoListViewDelegate: AnyObject {
    func showPhotos(_ photos: [PhotoEntity])
    func showError(_ message: String)
    func endRefreshing()
    func showLoadingMore(_ isLoading: Bool)
}

class PhotoListPresenter {
    weak var view: PhotoListViewDelegate?
    private let photoUseCase = UseCaseProvider.makeMediaUseCase()
    private var currentPage = 1
    private let pageSize = 100
    private var isLoading = false
    private var hasMore = true
    private var allPhotos: [PhotoEntity] = []
    private var filtered: [PhotoEntity] = []
    private var searchTask: DispatchWorkItem?
    private var keyword = ""

    init(view: PhotoListViewDelegate) {
        self.view = view
    }

    func loadInitial() {
        currentPage = 1
        hasMore = true
        allPhotos.removeAll()
        loadPhotos(page: currentPage)
    }

    func loadPhotos(page: Int) {
        isLoading = true
        view?.showLoadingMore(true)
        photoUseCase.fetchPhotos(page: page, limit: pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.view?.showLoadingMore(false)
            self.view?.endRefreshing()

            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    if photos.count < self.pageSize {
                        self.hasMore = false
                    }

                    self.allPhotos.append(contentsOf: photos)
                    self.filterPhotos()
                }
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }

    func loadMore() {
        guard !isLoading, hasMore else { return }
        isLoading = true
        currentPage += 1
        loadPhotos(page: currentPage)
    }

    func refresh() {
        loadInitial()
    }

    // MARK: - Search filter
    func updateSearch(text: String) {
        // Max 15 characters
        let limited = String(text.prefix(15))
        self.keyword = limited

        // Cancel old debounce
        searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.filterPhotos()
        }

        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }

    private func filterPhotos() {
        if keyword.isEmpty {
            filtered = allPhotos
        } else {
            let normalizedKey = keyword.normalized

            filtered = allPhotos.filter {
                let name = $0.author?.normalized ?? ""
                let id = $0.id?.normalized ?? ""
                return name.contains(normalizedKey) || id.contains(normalizedKey)
            }
        }

        view?.showPhotos(filtered)
    }
}
