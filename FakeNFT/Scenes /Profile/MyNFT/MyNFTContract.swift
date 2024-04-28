//
//  MyNFTContract.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 09.04.2024.
//

import Foundation

protocol MyNFTViewProtocol: AnyObject {
   // var presenter: MyNFTPresenterProtocol { get set }
    func displayMyNft(_ nft: [Nft])
    func loadingDataStarted()
    func loadingDataFinished()
    func setNftId(nftId: [String])
    func setLikedNftId(nftId: [String])
    func setProfileDelegate(delegate: ProfileViewControllerUpdateNftDelegate)
}

protocol MyNFTPresenterProtocol {
    var view: MyNFTViewProtocol? { get set }
    var delegate: ProfileViewControllerUpdateNftDelegate? { get set }
    func viewDidLoad()
    func loadMyNft()
    func setNftId(nftId: [String])
    func setLikedNftId(nftId: [String])
    func sortByName()
    func sortByPrice()
    func sortByRating()
    func getMyNft() -> [Nft]?
    func getLikedNftId() -> [String]
    func updateFavoriteNft(nftIds: [String])
    func setProfileDelegate(delegate: ProfileViewControllerUpdateNftDelegate)
}
