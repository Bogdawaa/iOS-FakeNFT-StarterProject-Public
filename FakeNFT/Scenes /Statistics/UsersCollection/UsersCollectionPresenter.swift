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
        if !nftsId.isEmpty && (nftsId.count != nftsCount()) {
            for id in nftsId {
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
            case .failure(let error):
                let errorModel = ErrorModel(
                    message: "Error.network"~,
                    actionText: "Error.repeat"~) { [weak self] in
                        guard let self else { return }
                        self.loadNft(with: id)
                }
                DispatchQueue.main.async {
                    self.view?.showError(errorModel)
                }
            }
        }
    }
}
