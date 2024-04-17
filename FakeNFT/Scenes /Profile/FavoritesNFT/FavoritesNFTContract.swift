//
//  FavoritesNFTContract.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 11.04.2024.
//

import Foundation

protocol FavoritesNFTViewProtocol: AnyObject {
    var presenter: FavoriteNFTPresenterProtocol { get set }
    func displayFavoritesNft(_ nft: [Nft])
    func loadingDataStarted()
    func loadingDataFinished()
    func setNftId(nftId: [String])
}

protocol FavoriteNFTPresenterProtocol {
    var view: FavoritesNFTViewProtocol? { get set }
    func viewDidLoad()
    func loadFavoriteNft()
    func setNftId(nftId: [String])
    func getFavoriteNft() -> [Nft]?
    func removeFavoriteNft(nftId: String)
}
