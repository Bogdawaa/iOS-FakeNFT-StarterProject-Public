//
//  UsersCollectionCellSupplementary.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit

class UsersCollectionCellFooter: UICollectionReusableView {

    // MARK: - properties
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
        object.textColor = .ypBlack
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    private lazy var nftPriceLabel: UILabel = {
        let object = UILabel()
        object.font = .caption3
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
        verticalContainer.addSubview(nftRatingImageView)
        verticalContainer.addSubview(nftNameLabel)
        verticalContainer.addSubview(nftPriceLabel)
        horizontalContainer.addSubview(verticalContainer)
        horizontalContainer.addSubview(cartButton)
        addSubview(horizontalContainer)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup data
    func setupFooterData(with nft: Nft) {
        self.nftNameLabel.text = nft.name
        self.nftPriceLabel.text = String(nft.price)

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

    // MARK: - constraints
    private func applyConstraints() {
        let horizontalContainerConstraints = [
            horizontalContainer.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            horizontalContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        let verticalContainerConstraints = [
            verticalContainer.topAnchor.constraint(equalTo: topAnchor),
            verticalContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalContainer.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),
            verticalContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
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
        NSLayoutConstraint.activate(horizontalContainerConstraints)
        NSLayoutConstraint.activate(verticalContainerConstraints)
        NSLayoutConstraint.activate(nftRatingImageViewConstraints)
        NSLayoutConstraint.activate(nftNameLabelConstraints)
        NSLayoutConstraint.activate(nftPriceLabelConstraints)
        NSLayoutConstraint.activate(cartButtonConstraints)
    }
}
