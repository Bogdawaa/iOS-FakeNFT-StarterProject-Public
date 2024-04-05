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
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    private lazy var nftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var nftPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var nftAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var nftRatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    private lazy var nftHeartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "suit.heart.fill")
        imageView.tintColor = .ypWhiteUniversal
        nftImageView.addSubview(imageView)
        return imageView
    }()
    // MARK: - INITIALIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NSLayoutConstraint.activate([contentView.heightAnchor.constraint(equalToConstant: 140)])
        contentView.backgroundColor = .ypWhite
        constraitsNftImageView()
        constraitsNftHeartImageView()
        constraitsNftTitleLabel()
        constraitsNftRatingImageView()
        constraitsNftAuthorLabel()
        constraitsNftPriceTitleLabel()
        constraitsNftPriceLabel()
        mockSetup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - MOCK SETUP
    private func mockSetup() {
        nftPriceLabel.text = "1,78 ETH"
        nftPriceTitleLabel.text = "Цена"
        nftTitleLabel.text = "Amogus"
        nftAuthorLabel.text = "от John Doe"
        nftImageView.image = .ypProfileNftMockImage
        nftRatingImageView.image = .ypProfileNftMockRatingImage
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
    private func constraitsNftHeartImageView() {
        NSLayoutConstraint.activate([
            nftHeartImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12),
            nftHeartImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -12)
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
            nftPriceTitleLabel.leadingAnchor.constraint(equalTo: nftRatingImageView.trailingAnchor, constant: 39),
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
