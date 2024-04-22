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
    private let service: NftService

    private var cart: [Nft] = []

    init(service: NftService) {
        self.service = service
    }
}

extension UsersCollectionPresenter: UsersCollectionPresenterProtocol {
    func viewDidLoad() {
        loadNfts()
    }

    func setNftsId(nftsId: [String]) {
        self.nftsId = nftsId
    }

    private func loadNfts() {
        if !nftsId.isEmpty {
            for id in nftsId where !nfts.contains(where: { $0.id == id }) {
                loadNft(with: id)
            }
        }
    }

    func nftsCount() -> Int {
        return nfts.count
    }

    func nftForIndex(indexPath: IndexPath) -> Nft {
        return nfts[indexPath.row]
    }

    func loadNft(with id: String) {
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

    func addToCart(nft: Nft) {
        // TODO: добавить переход в корзину в 4 спринте
        if !cart.contains(where: { $0.id == nft.id }) {
            self.cart.append(nft)
        } else {
            self.cart.removeAll(where: { $0.id == nft.id })
        }
    }
}
