//
//  RatingView.swift
//  FakeNFT
//
//  Created by admin on 26.03.2024.
//

import UIKit

final class RatingView: UIStackView {

    // MARK: - Initialisation

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Methods

    func update(rating: Int) {
        updateRating(rating: rating)
    }

    // MARK: - Private methods

    private func setupUI() {
        distribution = .fillEqually
        spacing = 2
        translatesAutoresizingMaskIntoConstraints = false
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = .ypTrash
            starImageView.contentMode = .scaleAspectFit
            NSLayoutConstraint.activate([
                starImageView.heightAnchor.constraint(equalToConstant: 12),
                starImageView.widthAnchor.constraint(equalToConstant: 12)
            ])
            addArrangedSubview(starImageView)
        }
    }

    private func updateRating(rating: Int) {
        for (index, subview) in arrangedSubviews.enumerated() {
            guard let starImageView = subview as? UIImageView else {
                continue
            }
            starImageView.image = index < rating ? UIImage.ypDoneStar : UIImage.ypEmptyStar
        }
    }
}