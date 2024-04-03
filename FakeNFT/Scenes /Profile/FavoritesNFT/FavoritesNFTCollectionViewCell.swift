//
//  favoritesNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 02.04.2024.
//

import Foundation
import UIKit

final class FavoritesNFTCollectionViewCell: UICollectionViewCell {
    // MARK: - identifier
    static let favoritesNftCellIdentifier = "favoritesNftCell"
    // MARK: - UI
    private lazy var favNftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        return imageView
    }()
    private lazy var favNftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var favNftRatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    private lazy var favNftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var favNftHeartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "suit.heart.fill")
        imageView.tintColor = .red
        favNftImageView.addSubview(imageView)
        return imageView
    }()
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .ypWhite
        constraitsFavNftImageView()
        constraitsfFavNftHeartImageView()
        constraitsFavNftTitleLabel()
        constraitsFavNftRatingImageView()
        constraitsFavNftPriceLabel()
        mockSetup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - PRIVATE
    private func mockSetup() {
        favNftImageView.image = .ypProfileNftMockImage
        favNftTitleLabel.text = "Amogus"
        favNftRatingImageView.image = .ypProfileNftMockRatingImage
        favNftPriceLabel.text = "1,78 ETH"
    }
    // MARK: - constraits
    private func constraitsFavNftImageView() {
        NSLayoutConstraint.activate([
            favNftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            favNftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            favNftImageView.widthAnchor.constraint(equalToConstant: 80),
            favNftImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    private func constraitsfFavNftHeartImageView() {
        NSLayoutConstraint.activate([
            favNftHeartImageView.heightAnchor.constraint(equalToConstant: 18),
            favNftHeartImageView.widthAnchor.constraint(equalToConstant: 21),
            favNftHeartImageView.trailingAnchor.constraint(equalTo: favNftImageView.trailingAnchor, constant: -5),
            favNftHeartImageView.topAnchor.constraint(equalTo: favNftImageView.topAnchor, constant: 6)
        ])
    }
    private func constraitsFavNftTitleLabel() {
        NSLayoutConstraint.activate([
            favNftTitleLabel.leadingAnchor.constraint(equalTo: favNftImageView.trailingAnchor, constant: 12),
            favNftTitleLabel.topAnchor.constraint(equalTo: favNftImageView.topAnchor, constant: 7)
        ])
    }
    private func constraitsFavNftRatingImageView() {
        NSLayoutConstraint.activate([
            favNftRatingImageView.leadingAnchor.constraint(equalTo: favNftTitleLabel.leadingAnchor),
            favNftRatingImageView.topAnchor.constraint(equalTo: favNftTitleLabel.bottomAnchor, constant: 8),
            favNftRatingImageView.heightAnchor.constraint(equalToConstant: 12),
            favNftRatingImageView.widthAnchor.constraint(equalToConstant: 68)
        ])
    }
    private func constraitsFavNftPriceLabel() {
        NSLayoutConstraint.activate([
            favNftPriceLabel.leadingAnchor.constraint(equalTo: favNftRatingImageView.leadingAnchor),
            favNftPriceLabel.topAnchor.constraint(equalTo: favNftRatingImageView.bottomAnchor, constant: 8)
        ])
    }
}
