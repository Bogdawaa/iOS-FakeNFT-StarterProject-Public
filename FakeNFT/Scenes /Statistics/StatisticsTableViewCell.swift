//
//  StatisticsTableViewCell.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

import UIKit

final class StatisticsTableViewCell: UITableViewCell {

    // MARK: - properties
    static let reuseIdentifier = "cell"

    private lazy var userImage: UIImageView = {
        let imgView = UIImageView()
        let img = UIImage(named: "sortButton")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private lazy var userName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.label
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var userScore: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.label
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var userRank: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.label
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - public methods
    func setupCell(rank: Int, name: String, score: String) {
        userRank.text = String(rank)
        userName.text = name
        userScore.text = score
    }

    // MARK: - private methods
    private func setupCellUI() {

        // contentview
        contentView.addSubview(userRank)
        contentView.addSubview(cardStackView)
        backgroundColor = .systemBackground

        // cardStackView
        cardStackView.addSubview(userImage)
        cardStackView.addSubview(userName)
        cardStackView.addSubview(userScore)
        cardStackView.backgroundColor = .segmentInactive

        // round userImage corners
        userImage.layer.cornerRadius = self.userImage.frame.size.width / 2

        applyConstraints()
    }

    private func applyConstraints() {
        let userRankConstraints = [
            userRank.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userRank.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userRank.heightAnchor.constraint(equalToConstant: 20),
            userRank.widthAnchor.constraint(equalToConstant: 30)
        ]
        let cardStackViewConstraints = [
            cardStackView.leadingAnchor.constraint(equalTo: userRank.trailingAnchor, constant: 8),
            cardStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cardStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ]
        let userImageConstraints = [
            userImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImage.leadingAnchor.constraint(equalTo: cardStackView.leadingAnchor, constant: 16),
            userImage.heightAnchor.constraint(equalToConstant: 28),
            userImage.widthAnchor.constraint(equalToConstant: 28)
        ]
        let userNameConstraints = [
            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 8),
            userName.centerYAnchor.constraint(equalTo: userImage.centerYAnchor),
            userName.trailingAnchor.constraint(equalTo: userScore.leadingAnchor, constant: -16),
            userName.heightAnchor.constraint(equalToConstant: 28)
        ]
        let userScoreConstraints = [
            userScore.centerYAnchor.constraint(equalTo: userImage.centerYAnchor),
            userScore.widthAnchor.constraint(equalToConstant: 38),
            userScore.trailingAnchor.constraint(equalTo: cardStackView.trailingAnchor, constant: -16),
            userScore.heightAnchor.constraint(equalToConstant: 28)
        ]
        NSLayoutConstraint.activate(userRankConstraints)
        NSLayoutConstraint.activate(cardStackViewConstraints)
        NSLayoutConstraint.activate(userImageConstraints)
        NSLayoutConstraint.activate(userNameConstraints)
        NSLayoutConstraint.activate(userScoreConstraints)
    }
}
