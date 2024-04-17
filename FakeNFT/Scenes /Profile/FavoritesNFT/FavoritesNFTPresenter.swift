//
//  FavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 11.04.2024.
//

import Foundation

final class FavoritesNFTPresenter: FavoriteNFTPresenterProtocol {

    // MARK: - view delegate
    weak var view: FavoritesNFTViewProtocol?
    // MARK: - nft
    var nftId: [String] = []
    private var myNft: [Nft] = []
    // MARK: - PRIVATE
    private let service: NftService
    // MARK: - INIT
    init(service: NftService) {
        self.service = service
    }
    // MARK: - public func
    func viewDidLoad() {
        loadFavoriteNft()
    }
    func loadFavoriteNft() {
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
    func getFavoriteNft() -> [Nft]? {
        return myNft
    }
    func setNftId(nftId: [String]) {
        self.nftId = nftId
    }
    func removeFavoriteNft(nftId: String) {
        self.nftId.removeAll(where: {
            $0 == nftId
        })
        self.myNft.removeAll(where: {
            $0.id == nftId
        })
        service.updateFavoritesNft(likedNftIds: self.nftId)
        view?.displayFavoritesNft(myNft)
    }
    // MARK: - private func
    private func addNft(newNft: Nft) {
        myNft.append(newNft)
        view?.displayFavoritesNft(myNft)
    }
}
