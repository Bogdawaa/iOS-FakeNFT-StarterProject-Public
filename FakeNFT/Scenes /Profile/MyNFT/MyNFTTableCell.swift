//
//  MyNFTTableCell.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 31.03.2024.
//

import Foundation
import UIKit

final class MyNFTTableCell: UITableViewCell {
    // MARK: - IDENTIFIER
    static let identifier = "myNftTableCell"
    // MARK: - UI
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ypProfileNftMockImage
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    private lazy var nftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "Amogus drip"
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var nftPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Цена"
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "1,78 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var nftAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "от John Doe"
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var nftRatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ypProfileNftMockRatingImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()

    // MARK: - INITIALIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NSLayoutConstraint.activate([contentView.heightAnchor.constraint(equalToConstant: 140)])
         contentView.backgroundColor = .ypWhite
        constraitsNftImageView()
        constraitsNftTitleLabel()
        constraitsNftRatingImageView()
        constraitsNftAuthorLabel()
        constraitsNftPriceTitleLabel()
        constraitsNftPriceLabel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - CONSTRAITS
    private func constraitsNftImageView() {
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
    }
    private func constraitsNftTitleLabel() {
        NSLayoutConstraint.activate([
            nftTitleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftTitleLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 23)
        ])
    }
    private func constraitsNftRatingImageView() {
        NSLayoutConstraint.activate([
            nftRatingImageView.leadingAnchor.constraint(equalTo: nftTitleLabel.leadingAnchor),
            nftRatingImageView.topAnchor.constraint(equalTo: nftTitleLabel.bottomAnchor, constant: 9),
            nftRatingImageView.heightAnchor.constraint(equalToConstant: 12),
            nftRatingImageView.widthAnchor.constraint(equalToConstant: 68)
        ])
    }
    private func constraitsNftAuthorLabel() {
        NSLayoutConstraint.activate([
            nftAuthorLabel.leadingAnchor.constraint(equalTo: nftRatingImageView.leadingAnchor),
            nftAuthorLabel.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor, constant: 9)
        ])
    }
    private func constraitsNftPriceTitleLabel() {
        NSLayoutConstraint.activate([
            nftPriceTitleLabel.leadingAnchor.constraint(equalTo: nftTitleLabel.trailingAnchor, constant: 39),
            nftPriceTitleLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 33)
        ])
    }
    private func constraitsNftPriceLabel() {
        NSLayoutConstraint.activate([
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftPriceTitleLabel.leadingAnchor),
            nftPriceLabel.topAnchor.constraint(equalTo: nftPriceTitleLabel.bottomAnchor, constant: 2)
        ])
    }
}
