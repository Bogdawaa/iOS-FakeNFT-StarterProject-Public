//
//  UsersCollectionPresenter.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import Foundation

class UsersCollectionPresenter {
    weak var view: UsersCollectionViewProtocol?

    private var nftsId: [String] = []
    private var nfts: [Nft] = []
    private var nftsInCart: [Nft] = []
    private var nftsInFavourites: [String] = []

    private let service: NftService
    private let serviceCart: CartService
    private let serviceProfile: ProfileService

    private let id = "1"

    init(service: NftService, serviceCart: CartService, serviceProfile: ProfileService) {
        self.service = service
        self.serviceCart = serviceCart
        self.serviceProfile = serviceProfile
    }
}

extension UsersCollectionPresenter: UsersCollectionPresenterProtocol {
    func viewDidLoad() {
        loadNfts()
        updateCart()
        loadProfile()
    }

    func setNftsId(nftsId: [String]) {
        self.nftsId = nftsId
    }

    func nftsCount() -> Int {
        return nfts.count
    }

    func nftForIndex(indexPath: IndexPath) -> Nft {
        return nfts[indexPath.row]
    }

    func cartContainsNft(nft: Nft) -> Bool {
        nftsInCart.contains(where: { $0.id == nft.id })
    }

    func isInFavourites(nft: Nft) -> Bool {
        nftsInFavourites.contains(where: { $0 == nft.id })
    }

    private func loadNfts() {
        if !nftsId.isEmpty {
            for id in nftsId where !nfts.contains(where: { $0.id == id }) {
                loadNft(with: id)
            }
        }
    }

    private func loadNft(with id: String) {
        view?.loadingDataStarted()
        service.loadNft(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nft):
                DispatchQueue.main.async {
                    self.view?.loadingDataFinished()
                    self.nfts.append(nft)
                    self.view?.reloadCollectionView()
                }
            case .failure:
                let errorModel = ErrorModel(
                    message: "Error.network"~,
                    actionText: "Error.repeat"~
                ) { [weak self] in
                    guard let self else { return }
                    self.loadNft(with: id)
                }
                DispatchQueue.main.async {
                    self.view?.showError(errorModel)
                }
            }
        }
    }

    func addOrDeleteFromCart(nft: Nft) {
        if nftsInCart.contains(where: { $0.id == nft.id }) {
            self.deleteFromCart(nft: nft)
        } else {
            addToCart(nft: nft)
        }
    }

    private func addToCart(nft: Nft) {
        if nftsInCart.isEmpty {
            nftsInCart.append(nft)
        }
        nftsInCart.append(nft)
        let nftsID = nftsInCart.map { $0.id }
        serviceCart.updateFromCart(id: id, nftsID: nftsID) { _ in }
    }

    private func deleteFromCart(nft: Nft) {
        nftsInCart.removeAll(where: { $0.id == nft.id })
        let nftsID = nftsInCart.map { $0.id }
        serviceCart.updateFromCart(id: id, nftsID: nftsID) { _ in }
    }

    private func updateCart() {
        serviceCart.downloadServiceNFTs(with: id) { result in
            switch result {
            case .success(let nftsInCart):
                DispatchQueue.main.async {
                    self.nftsInCart = nftsInCart
                    self.view?.reloadCollectionView()
                }
            case .failure:
                let errorModel = ErrorModel(
                    message: "Error.network"~,
                    actionText: "Error.repeat"~
                ) { [weak self] in
                    guard let self else { return }
                    self.updateCart()
                }
                DispatchQueue.main.async {
                    self.view?.showError(errorModel)
                }
            }
        }
    }

    private func loadProfile() {
        serviceProfile.loadProfile(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.nftsInFavourites = profile.likes
                    self.view?.reloadCollectionView()
                }
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }

    func updateFavoriteNft(nftId: String) {
        if nftsInFavourites.contains(where: { $0 == nftId }) {
            nftsInFavourites.removeAll(where: { $0 == nftId })
        } else {
            nftsInFavourites.append(nftId)
        }
        service.updateFavoritesNft(likedNftIds: nftsInFavourites)
    }
}
