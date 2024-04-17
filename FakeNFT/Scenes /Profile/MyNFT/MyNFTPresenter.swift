//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 09.04.2024.
//

import Foundation

final class MyNFTPresenter: MyNFTPresenterProtocol {

    // MARK: - view delegate
    var view: MyNFTViewProtocol?
    // MARK: - nft
    private var nftId: [String] = []
    private var likedNftId: [String] = []
    private var myNft: [Nft] = []
    // MARK: - PRIVATE
    private let service: NftService
    // MARK: - INIT
    init(service: NftService) {
        self.service = service
    }
    // MARK: - viewDidLoad
    func viewDidLoad() {
        myNft = []
        loadMyNft()
    }
    // MARK: - sort
    func sortByName() {
        myNft.sort {
            $0.name < $1.name
        }
        view?.displayMyNft(myNft)
    }
    func sortByPrice() {
        myNft.sort {
            $0.price > $1.price
        }
        view?.displayMyNft(myNft)
    }
    func sortByRating() {
        myNft.sort {
            $0.rating > $1.rating
        }
        view?.displayMyNft(myNft)
    }
    // MARK: - loadMyNft
    func loadMyNft() {
        view?.loadingDataStarted()
        nftId.forEach { nft in
            service.loadNft(id: nft) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    DispatchQueue.main.async {
                        self.addNft(newNft: nft)
                    }
                case .failure(let error):
                    assertionFailure("\(error)")
                }
            }
        }
    }
    // MARK: - setNft
    func setNftId(nftId: [String]) {
        self.nftId = nftId
    }
    func setLikedNftId(nftId: [String]) {
        self.likedNftId = nftId
    }
    // MARK: - getNft
    func getMyNft() -> [Nft]? {
        return myNft
    }
    func getLikedNftId() -> [String] {
        return likedNftId
    }
    // MARK: - updateNft
    private func addNft(newNft: Nft) {
        myNft.append(newNft)
        view?.displayMyNft(myNft)
    }
    func updateFavoriteNft(nftIds: [String]) {
        setLikedNftId(nftId: nftIds)
        service.updateFavoritesNft(likedNftIds: nftIds)
        view?.displayMyNft(myNft)
    }
}
