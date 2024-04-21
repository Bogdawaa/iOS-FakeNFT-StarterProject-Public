//
//  UsersCollectionContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit

protocol UsersCollectionViewProtocol: AnyObject {
    var presenter: UsersCollectionPresenterProtocol { get set }
}

protocol UsersCollectionPresenterProtocol {
    var view: UsersCollectionViewProtocol? { get set }
    func viewDidLoad()
    func nftsCount() -> Int
    func nftForIndex(indexPath: IndexPath) -> String // TODO: должна возвращать NFT
}
