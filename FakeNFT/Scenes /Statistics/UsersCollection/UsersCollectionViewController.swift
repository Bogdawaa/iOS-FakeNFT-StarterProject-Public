//
//  UsersCollectionViewController.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit

class UsersCollectionViewController: UIViewController {

    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 108, height: 108) // TODO: ??
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.register(UsersCollectionCell.self)
        return object
    }()
}
