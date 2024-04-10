//
//  MyNFTContract.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 09.04.2024.
//

import Foundation

protocol MyNFTViewProtocol {
    var presenter: MyNFTPresenterProtocol { get set }
    func displayMyNft(_ nft: [Nft])
    func loadingDataStarted()
    func loadingDataFinished()
    func setNftId(nftId: [String])
}

protocol MyNFTPresenterProtocol {
    var view: MyNFTViewProtocol? { get set }
    func viewDidLoad()
    func loadMyNft()
    func setNftId(nftId: [String])
    func getMyNft() -> [Nft]?
}
