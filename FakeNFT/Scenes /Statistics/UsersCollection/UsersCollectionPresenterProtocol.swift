//
//  UsersCollectionPresenterProtocol.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 25.04.2024.
//

import UIKit

protocol UsersCollectionPresenterProtocol {
    var view: UsersCollectionViewProtocol? { get set }
    func viewDidLoad()
    func nftsCount() -> Int
    func nftForIndex(indexPath: IndexPath) -> Nft
    func setNftsId(nftsId: [String])
    func addOrDeleteFromCart(nft: Nft)
    func cartContainsNft(nft: Nft) -> Bool
    func isInFavourites(nft: Nft) -> Bool
    func updateFavoriteNft(nftId: String)
}
