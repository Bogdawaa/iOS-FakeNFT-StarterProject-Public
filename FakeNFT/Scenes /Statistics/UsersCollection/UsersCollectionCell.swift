//
//  UsersCollectionCell.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit

final class UsersCollectionCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - properties
    lazy var nftImageView: UIImageView = {
        let object = UIImageView()
        object.layer.masksToBounds = true
        object.clipsToBounds = true
        object.layer.cornerRadius = 12
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var nftFaVouriteButton: UIButton = {
        let object = UIButton()
        object.setImage(.ypFavouriteButtonInactive, for: .normal)
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var nftRatingImageView: UIImageView = {
        let object = UIImageView()
        let image = UIImage.ypRatingZero
        object.image = image
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var horizontalContainer: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var verticalContainer: UIStackView = {
        let object = UIStackView()
        object.axis = .vertical
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var nftNameLabel: UILabel = {
        let object = UILabel()
        object.font = .bodyBold
        object.text = "1fafa"
        object.textColor = .ypBlack
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var nftPriceLabel: UILabel = {
        let object = UILabel()
        object.font = .caption3
        object.text = "1fafa"
        object.textColor = .ypBlack
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var cartButton: UIButton = {
        let object = UIButton()
        let image = UIImage.ypCartButton
        object.setImage(image, for: .normal)
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(nftImageView)
        contentView.addSubview(nftFaVouriteButton)

        verticalContainer.addSubview(nftRatingImageView)
        verticalContainer.addSubview(nftNameLabel)
        verticalContainer.addSubview(nftPriceLabel)
        horizontalContainer.addSubview(verticalContainer)
        horizontalContainer.addSubview(cartButton)
        contentView.addSubview(horizontalContainer)

        applyConstaints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup data
    func setupData(with nft: Nft) {
        self.nftNameLabel.text = nft.name
        self.nftPriceLabel.text = String(nft.price) + " ETH"

        switch nft.rating {
        case 0:
            self.nftRatingImageView.image = .ypRatingZero
        case 1:
            self.nftRatingImageView.image = .ypRatingOne
        case 2:
            self.nftRatingImageView.image = .ypRatingTwo
        case 3:
            self.nftRatingImageView.image = .ypRatingThree
        case 4:
            self.nftRatingImageView.image = .ypRatingFour
        case 5:
            self.nftRatingImageView.image = .ypRatingFive
        default:
            self.nftRatingImageView.image = .ypRatingZero
        }
    }

    private func applyConstaints() {
        let nftImageViewConstraints = [
            nftImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)
        ]
        let nftFaVouriteButtonConstraints = [
            nftFaVouriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftFaVouriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            nftFaVouriteButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        let horizontalContainerConstraints = [
            horizontalContainer.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            horizontalContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalContainer.heightAnchor.constraint(equalToConstant: 84)
        ]
        let verticalContainerConstraints = [
            verticalContainer.topAnchor.constraint(equalTo: horizontalContainer.topAnchor),
            verticalContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalContainer.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),
            verticalContainer.bottomAnchor.constraint(equalTo: horizontalContainer.bottomAnchor, constant: -20)
        ]
        let nftRatingImageViewConstraints = [
            nftRatingImageView.topAnchor.constraint(equalTo: verticalContainer.topAnchor),
            nftRatingImageView.leadingAnchor.constraint(equalTo: verticalContainer.leadingAnchor),
            nftRatingImageView.trailingAnchor.constraint(equalTo: verticalContainer.trailingAnchor),
            nftRatingImageView.heightAnchor.constraint(equalToConstant: 12)
        ]
        let nftNameLabelConstraints = [
            nftNameLabel.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: verticalContainer.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: verticalContainer.trailingAnchor)
        ]
        let nftPriceLabelConstraints = [
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: verticalContainer.leadingAnchor),
            nftPriceLabel.trailingAnchor.constraint(equalTo: verticalContainer.trailingAnchor)
        ]
        let cartButtonConstraints = [
            cartButton.topAnchor.constraint(equalTo: verticalContainer.topAnchor, constant: 16),
            cartButton.trailingAnchor.constraint(equalTo: horizontalContainer.trailingAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(nftImageViewConstraints)
        NSLayoutConstraint.activate(nftFaVouriteButtonConstraints)
        NSLayoutConstraint.activate(horizontalContainerConstraints)
        NSLayoutConstraint.activate(verticalContainerConstraints)
        NSLayoutConstraint.activate(nftRatingImageViewConstraints)
        NSLayoutConstraint.activate(nftNameLabelConstraints)
        NSLayoutConstraint.activate(nftPriceLabelConstraints)
        NSLayoutConstraint.activate(cartButtonConstraints)
    }
}
