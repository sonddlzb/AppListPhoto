//
//  PhotoListViewController.swift
//  AppListPhoto
//
//  Created by đào sơn on 21/11/25.
//

import UIKit
import Domain

class PhotoListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: IconTextField!
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    // MARK: - Variables
    private var presenter: PhotoListPresenter!
    private var photos: [PhotoEntity] = []
    private var isLoadingMore = false

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PhotoListPresenter(view: self)

        configUI()
        presenter.loadInitial()
    }

    // MARK: - Config
    private func configUI() {
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(type: PhotoCell.self)

        // Pull to refresh
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)

        // Loading footer
        let footer = UIActivityIndicatorView()
        footer.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        footer.hidesWhenStopped = true
        tableView.tableFooterView = footer

        searchTextField.leftIcon = .icSearch
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)

        // tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        // accessibilityIdentifier for UITesting
        searchTextField.accessibilityIdentifier = "searchTextField"
        tableView.accessibilityIdentifier = "photoTableView"
        refreshControl.accessibilityIdentifier = "refreshIndicator"
    }

    // MARK: - Actions
    @objc private func onPullToRefresh() {
        presenter.refresh()
    }

    @objc private func searchChanged(_ sender: UITextField) {
        presenter.updateSearch(text: sender.text ?? "")
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(type: PhotoCell.self) else {
            return UITableViewCell()
        }

        if let photo = self.photos[safe: indexPath.row] {
            cell.bind(photo: photo)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = self.photos[safe: indexPath.row],
              let width = photo.width,
              let height = photo.height else {
            return 0
        }

        let visibleWidth = tableView.frame.width
        let bottomPadding = 84.0
        let visibleHeight = visibleWidth * (CGFloat(height) / CGFloat(width)) + bottomPadding
        return visibleHeight
    }
}

// MARK: - PhotoListViewDelegate
extension PhotoListViewController: PhotoListViewDelegate {
    func showPhotos(_ photos: [PhotoEntity]) {
        let oldPhotos = self.photos
        self.photos = photos

        DispatchQueue.main.async {
            self.tableView.performBatchUpdates({
                // Remove not existed row
                let removedIndexPaths = oldPhotos.enumerated()
                    .filter { oldPhoto in
                        !photos.contains { $0.id == oldPhoto.element.id }
                    }
                    .map { IndexPath(row: $0.offset, section: 0) }
                self.tableView.deleteRows(at: removedIndexPaths, with: .fade)

                // Add new row
                let addedIndexPaths = photos.enumerated()
                    .filter { photo in
                        !oldPhotos.contains { $0.id == photo.element.id }
                    }                    .map { IndexPath(row: $0.offset, section: 0) }
                self.tableView.insertRows(at: addedIndexPaths, with: .fade)
            }, completion: nil)
        }
    }

    func showError(_ message: String) {
        self.showAlert(title: message)
    }

    func endRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }

    func showLoadingMore(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoadingMore = isLoading

            if let footer = self.tableView.tableFooterView as? UIActivityIndicatorView {
                isLoading ? footer.startAnimating() : footer.stopAnimating()
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension PhotoListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        let bottomPadding = 100.0

        if offsetY > contentHeight - height - bottomPadding {
            presenter.loadMore()
        }
    }
}

// MARK: - UITextFieldDelegate
extension PhotoListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!0#$$^&*():.,<>/\\()?")
        let filtered = string.unicodeScalars.filter { allowedCharacterSet.contains($0) }
        let filteredString = String(String.UnicodeScalarView(filtered))

        if filteredString != string {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let newText = text.replacingCharacters(in: textRange, with: filteredString)
                textField.text = newText
            }
            return false
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
