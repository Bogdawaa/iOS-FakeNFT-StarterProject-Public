//
//  UsersCollectionContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit

protocol UsersCollectionViewProtocol: AnyObject, ErrorView, LoadingView {
    var presenter: UsersCollectionPresenterProtocol { get set }
    func reloadCollectionView()
    func loadingDataStarted()
    func loadingDataFinished()
}

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
