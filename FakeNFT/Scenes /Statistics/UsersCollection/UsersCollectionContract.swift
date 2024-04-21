//
//  UsersCollectionContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit

protocol UsersCollectionViewProtocol: AnyObject {
    var presenter: UsersCollectionPresenterProtocol { get set }
    func reloadCollectionView(indexPath: IndexPath)
}

protocol UsersCollectionPresenterProtocol {
    var view: UsersCollectionViewProtocol? { get set }
    func viewDidLoad()
    func nftsCount() -> Int
    func nftForIndex(indexPath: IndexPath) -> Nft
    func setNftsId(nftsId: [String])
}
