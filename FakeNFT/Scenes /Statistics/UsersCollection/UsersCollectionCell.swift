//
//  UsersCollectionCell.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit

final class UsersCollectionCell: UICollectionViewCell, ReuseIdentifying {
//    static let identifier = "usersCollectionCellIdentifier"

    private lazy var nftImageView: UIImageView = {
        let object = UIImageView()
        object.layer.masksToBounds = true
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var nftFaVouriteButton: UIButton = {
        let object = UIButton()
        object.setImage(.ypFavouriteButtonInactive, for: .normal)
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nftImageView)
        contentView.addSubview(nftFaVouriteButton)
        applyConstaints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyConstaints() {
        let nftImageViewConstraints = [
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)
        ]
        let nftFaVouriteButtonConstraints = [
            nftFaVouriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftFaVouriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            nftFaVouriteButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(nftImageViewConstraints)
        NSLayoutConstraint.activate(nftFaVouriteButtonConstraints)
    }
}

class UsersCollectionCellFooter: UICollectionViewCell {
    private lazy var nftRatingImageView: UIImageView = {
        let object = UIImageView()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var nftNameLabel: UILabel = {
        let object = UILabel()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var nftPriceLabel: UILabel = {
        let object = UILabel()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var cartButton: UIButton = {
        let object = UIButton()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
}
