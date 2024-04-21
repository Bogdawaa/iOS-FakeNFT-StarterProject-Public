//
//  UsersCollectionPresenter.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import Foundation

class UsersCollectionPresenter {
    weak var view: UsersCollectionViewProtocol?

    private(set) var nftsId: [String]

    init(nfts: [String]) {
        self.nftsId = nfts
    }
}

extension UsersCollectionPresenter: UsersCollectionPresenterProtocol {
    func viewDidLoad() {
        //
    }

    func nftsCount() -> Int {
        return nftsId.count
    }

    func nftForIndex(indexPath: IndexPath) -> String {
        // TODO: функция должна возвращать NFT  а не строку
        return nftsId[indexPath.row]
    }
}
