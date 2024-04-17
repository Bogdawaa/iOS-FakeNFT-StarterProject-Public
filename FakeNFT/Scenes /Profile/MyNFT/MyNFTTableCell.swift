//
//  MyNFTTableCell.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 31.03.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol MyNFTTableCellDelegate: AnyObject {
    func setLike(nftId: String)
    func removeLike(nftId: String)
}
final class MyNFTTableCell: UITableViewCell {
    // MARK: - IDENTIFIER
    static let identifier = "myNftTableCell"
    // MARK: - DELEGATE
    weak var delegate: MyNFTTableCellDelegate?
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
    private lazy var nftHeartButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "suit.heart.fill") ?? UIImage(),
            target: self,
            action: #selector(didTapHeartButton)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypWhiteUniversal
        contentView.addSubview(button)
        return button
    }()
    // MARK: - private
    private var isLiked = false
    private var nftId: String = ""
    // MARK: - INITIALIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NSLayoutConstraint.activate([contentView.heightAnchor.constraint(equalToConstant: 140)])
        contentView.backgroundColor = .ypWhite
        constraitsNftImageView()
        constraitsNftHeartButton()
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
    // MARK: - public configure
    func configure(
        nftImageURL: URL?,
        nftTitle: String,
        nftPrice: Float,
        nftAuthor: String,
        nftRatingStars: Int,
        nftIsLiked: Bool,
        nftId: String
    ) {
        self.nftId = nftId
        self.isLiked = nftIsLiked
        nftHeartButton.tintColor = nftIsLiked ? .ypRedUniversal : .ypWhiteUniversal
        self.nftTitleLabel.text = nftTitle
        self.nftPriceLabel.text = String(nftPrice)
        self.nftAuthorLabel.text = nftAuthor
        if let url = nftImageURL {
            nftImageView.kf.setImage(
                with: url
            )
        }
        switch nftRatingStars {
        case 0:
            nftRatingImageView.image = .ypProfileNftRatingImage0
        case 1:
            nftRatingImageView.image = .ypProfileNftRatingImage1
        case 2:
            nftRatingImageView.image = .ypProfileNftRatingImage2
        case 3:
            nftRatingImageView.image = .ypProfileNftRatingImage3
        case 4:
            nftRatingImageView.image = .ypProfileNftRatingImage4
        case 5:
            nftRatingImageView.image = .ypProfileNftRatingImage5
        default:
            break
        }
    }
    // MARK: - MOCK SETUP
    private func mockSetup() {
        nftPriceLabel.text = "1,78 ETH"
        nftPriceTitleLabel.text = "Цена"
        nftTitleLabel.text = "Amogus"
        nftAuthorLabel.text = "от John Doe"
        nftImageView.image = .ypProfileNftMockImage
        nftRatingImageView.image = .ypProfileNftRatingImage3
    }
    // MARK: - OBJC
    @objc
    private func didTapHeartButton(_ sender: UIButton) {
        isLiked.toggle()
        if isLiked {
            nftHeartButton.tintColor = .ypRedUniversal
            delegate?.setLike(nftId: nftId)
        } else {
            nftHeartButton.tintColor = .ypWhiteUniversal
            delegate?.removeLike(nftId: nftId)
        }
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
    private func constraitsNftHeartButton() {
        NSLayoutConstraint.activate([
            nftHeartButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12),
            nftHeartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -12)
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
            nftPriceTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -81),
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
