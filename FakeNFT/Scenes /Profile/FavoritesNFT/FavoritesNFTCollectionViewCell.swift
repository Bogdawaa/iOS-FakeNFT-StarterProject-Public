//
//  favoritesNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 02.04.2024.
//

import Foundation
import UIKit

protocol FavoritesNFTCollectionViewCellDelegate: AnyObject {
    func removeLike(nftId: String)
}

final class FavoritesNFTCollectionViewCell: UICollectionViewCell {
    // MARK: - identifier
    static let favoritesNftCellIdentifier = "favoritesNftCell"
    // MARK: - delegate
    weak var delegate: FavoritesNFTCollectionViewCellDelegate?
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
        // label.font = .bodyBold
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
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
        // label.font = .caption1
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var favNftHeartButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "suit.heart.fill") ?? UIImage(),
            target: self,
            action: #selector(didTapHeartButton)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRedUniversal
        addSubview(button)
        return button
    }()
    // MARK: - PRIVATE VARIABLES
    private var nftId: String = ""
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .ypWhite
        constraitsFavNftImageView()
         constraitsfFavNftHeartButton()
        constraitsFavNftTitleLabel()
        constraitsFavNftRatingImageView()
        constraitsFavNftPriceLabel()
        mockSetup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - PUBLIC FUNC
    func configureFavNftCell(
        favNftImageUrl: URL?,
        favNftTitle: String,
        favNftRaiting: Int,
        favNftPrice: Float,
        favnftId: String
    ) {
        if let url = favNftImageUrl {
            favNftImageView.kf.setImage(
                with: url
            )
        }
        self.nftId = favnftId
        favNftTitleLabel.text = favNftTitle
        favNftPriceLabel.text = String(favNftPrice).replacingOccurrences(of: ".", with: ",") + " ETH"
        switch favNftRaiting {
        case 0:
            favNftRatingImageView.image = .ypProfileNftRatingImage0
        case 1:
            favNftRatingImageView.image = .ypProfileNftRatingImage1
        case 2:
            favNftRatingImageView.image = .ypProfileNftRatingImage2
        case 3:
            favNftRatingImageView.image = .ypProfileNftRatingImage3
        case 4:
            favNftRatingImageView.image = .ypProfileNftRatingImage4
        case 5:
            favNftRatingImageView.image = .ypProfileNftRatingImage5
        default:
            break
        }
    }
    // MARK: - OBJC
    @objc
    private func didTapHeartButton(_ sender: UIButton) {
        delegate?.removeLike(nftId: self.nftId)
    }
    // MARK: - PRIVATE
    private func mockSetup() {
        favNftImageView.image = .ypProfileNftMockImage
        favNftTitleLabel.text = "Amogus"
        favNftRatingImageView.image = .ypProfileNftRatingImage3
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
    private func constraitsfFavNftHeartButton() {
        NSLayoutConstraint.activate([
            favNftHeartButton.heightAnchor.constraint(equalToConstant: 18),
            favNftHeartButton.widthAnchor.constraint(equalToConstant: 21),
            favNftHeartButton.trailingAnchor.constraint(equalTo: favNftImageView.trailingAnchor, constant: -5),
            favNftHeartButton.topAnchor.constraint(equalTo: favNftImageView.topAnchor, constant: 6)
        ])
    }
    private func constraitsFavNftTitleLabel() {
        NSLayoutConstraint.activate([
            favNftTitleLabel.leadingAnchor.constraint(equalTo: favNftImageView.trailingAnchor, constant: 12),
            favNftTitleLabel.topAnchor.constraint(equalTo: favNftImageView.topAnchor, constant: 7),
            favNftTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    private func constraitsFavNftRatingImageView() {
        NSLayoutConstraint.activate([
            favNftRatingImageView.leadingAnchor.constraint(equalTo: favNftTitleLabel.leadingAnchor),
            favNftRatingImageView.topAnchor.constraint(equalTo: favNftTitleLabel.bottomAnchor, constant: 1),
            favNftRatingImageView.heightAnchor.constraint(equalToConstant: 12),
            favNftRatingImageView.widthAnchor.constraint(equalToConstant: 68)
        ])
    }
    private func constraitsFavNftPriceLabel() {
        NSLayoutConstraint.activate([
            favNftPriceLabel.leadingAnchor.constraint(equalTo: favNftRatingImageView.leadingAnchor),
            favNftPriceLabel.topAnchor.constraint(equalTo: favNftRatingImageView.bottomAnchor, constant: 3)
        ])
    }
}
