//
//  UsersCollectionPresenter.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import Foundation

class UsersCollectionPresenter {
    weak var view: UsersCollectionViewProtocol?

    private(set) var nftsId: [String] = []
    private(set) var nfts: [Nft] = []
    private(set) var nftsInCart: [Nft] = []

    private let service: NftService
    private let serviceCart: CartService

    private let id = "1"

    init(service: NftService, serviceCart: CartService) {
        self.service = service
        self.serviceCart = serviceCart
    }
}

extension UsersCollectionPresenter: UsersCollectionPresenterProtocol {
    func viewDidLoad() {
        loadNfts()
        updateCart()
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
                self.nftsInCart = nftsInCart
                DispatchQueue.main.async {
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
}
