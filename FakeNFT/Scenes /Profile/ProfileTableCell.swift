//
//  ProfileTableCell.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 30.03.2024.
//

import Foundation
import UIKit

final class ProfileTableCell: UITableViewCell {
    // MARK: - Identifier
    static let Identifier = "ProfileCell"
    // MARK: - UI
    private lazy var chevronImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleToFill
        imageView.image = image
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = .bodyBold
        constraitsChevronImage()
        NSLayoutConstraint.activate([contentView.heightAnchor.constraint(equalToConstant: 54)])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - CONSTRAITS
    private func constraitsChevronImage() {
        NSLayoutConstraint.activate([
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
