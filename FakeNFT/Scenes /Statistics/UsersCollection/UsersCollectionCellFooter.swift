//
//  UsersCollectionCellSupplementary.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import Foundation

class UsersCollectionCellSupplementary: UICollectionReusableView {
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
