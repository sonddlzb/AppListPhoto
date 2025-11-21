//
//  PhotoCell.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//

import UIKit
import Domain

class PhotoCell: UITableViewCell {
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    private var loadID: UUID?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.showSkeleton()
        photoImageView.image = nil
        if let id = loadID {
            ImageLoader.shared.cancel(id)
        }
        lblAuthor.text = nil
        lblSize.text = nil
    }

    func bind(photo: PhotoEntity) {
        lblAuthor.text = photo.author
        if let width = photo.width, let height = photo.height {
            lblSize.text = "Size: \(width)x\(height)"
        }

        if let urlString = photo.downloadUrl, let url = URL(string: urlString) {
            photoImageView.showSkeleton()
            loadID = ImageLoader.shared.load(url) { [weak self] img in
                DispatchQueue.main.async {
                    self?.photoImageView.hideSkeleton()
                    self?.photoImageView.image = img
                }
            }
        }
    }
}
