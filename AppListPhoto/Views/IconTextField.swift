//
//  IconTextField.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//


import UIKit

class IconTextField: UITextField {
    // MARK: - Variables
    private let defaultCornerRadius: CGFloat = 8
    private let defaultBorderWidth: CGFloat = 1.0
    private let defaultBorderColor: UIColor = .lightGray
    var leftIcon: UIImage? {
        didSet {
            setupLeftIcon()
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = defaultCornerRadius
        layer.borderWidth = defaultBorderWidth
        layer.borderColor = defaultBorderColor.cgColor
        clipsToBounds = true

        setupLeftIcon()
    }

    private func setupLeftIcon() {
        guard let iconImage = leftIcon else {
            leftView = nil
            leftViewMode = .never
            return
        }

        let iconSize: CGFloat = 20
        let iconPadding: CGFloat = 10
        let internalPadding: CGFloat = 10
        let totalWidth = iconSize + iconPadding + internalPadding

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: totalWidth, height: frame.height))

        let iconImageView = UIImageView(frame: CGRect(x: internalPadding,
                                                      y: (frame.height - iconSize) / 2,
                                                      width: iconSize,
                                                      height: iconSize))

        iconImageView.image = iconImage
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = self.textColor ?? .gray

        paddingView.addSubview(iconImageView)

        leftView = paddingView
        leftViewMode = .always
    }


    override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftView = leftView else {
            return bounds.insetBy(dx: 10, dy: 0)
        }

        let x = leftView.frame.width
        let rightPadding = 10.0
        let width = bounds.width - x - rightPadding

        return CGRect(x: x, y: 0, width: width, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
