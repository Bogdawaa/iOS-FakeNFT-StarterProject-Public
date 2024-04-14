//
//  FavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 11.04.2024.
//

import Foundation

final class FavoritesNFTPresenter: FavoriteNFTPresenterProtocol {
    // MARK: - view delegate
    var view: FavoritesNFTViewProtocol?
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
                        self.updateNft(newNft: nft)
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
    private func updateNft(newNft: Nft) {
        myNft.append(newNft)
        view?.displayFavoritesNft(myNft)
    }
}
