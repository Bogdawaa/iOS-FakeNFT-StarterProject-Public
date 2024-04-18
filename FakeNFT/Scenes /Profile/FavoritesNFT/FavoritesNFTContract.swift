//
//  FavoritesNFTContract.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 11.04.2024.
//

import Foundation

protocol FavoritesNFTViewProtocol: AnyObject {
    func displayFavoritesNft(_ nft: [Nft])
    func loadingDataStarted()
    func loadingDataFinished()
    func setNftId(nftId: [String])
    func setProfileDelegate(delegate: ProfileViewControllerUpdateNftDelegate)
}

protocol FavoriteNFTPresenterProtocol {
    var view: FavoritesNFTViewProtocol? { get set }
    var delegate: ProfileViewControllerUpdateNftDelegate? { get set }
    func viewDidLoad()
    func loadFavoriteNft()
    func setNftId(nftId: [String])
    func getFavoriteNft() -> [Nft]?
    func removeFavoriteNft(nftId: String)
}
