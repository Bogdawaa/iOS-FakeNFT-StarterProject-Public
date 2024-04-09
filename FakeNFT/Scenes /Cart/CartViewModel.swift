//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by admin on 25.03.2024.
//

import Foundation

enum SortList: String {
    case price
    case rating
    case name
}

final class CartViewModel {
    @Observable var nfts: [Nft] = []
    @Observable var loadingErrorNFT: Bool?
    private let service: CartService
    private let id = "1"

    // MARK: - Initialisation

    init(service: CartService) {
        self.service = service
    }

    // MARK: - Methods

    func updateCart() {
        loadNfts()
    }

    func countingTheTotalAmount() -> Float {
        var total: Float = 0.0
        nfts.forEach {
            total += $0.price
        }
        return roundToTwoDecimalPlaces(total)
    }

    func removeItemFromCart(idNFT: String) {
        nfts.removeAll(where: {
            $0.id == idNFT
        })
        loadingLastSort()
        let nftsID = nfts.map { $0.id }
        service.updateFromCart(id: id, nftsID: nftsID) {_ in }
    }

    func loadingLastSort() {
        if let savedSortingData = UserDefaults.standard.string(forKey: "sortingKey") {
            if let sortValue = SortList(rawValue: savedSortingData) {
                sorting(with: sortValue)
            }
        }
    }

    func sorting(with sortList: SortList) {
        switch sortList {
        case .price:
            nfts = nfts.sorted { $0.price > $1.price }
        case .rating:
            nfts = nfts.sorted { $0.rating > $1.rating }
        case .name:
            nfts = nfts.sorted { $0.name < $1.name }
        }
        UserDefaults.standard.set(sortList.rawValue, forKey: "sortingKey")
    }

    // MARK: - Private methods

    private func roundToTwoDecimalPlaces(_ value: Float) -> Float {
        let divisor = pow(10.0, Float(2))
        return (value * divisor).rounded() / divisor
    }

    private func loadNfts() {
        service.downloadServiceNFTs(with: id) { result in
            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.loadingLastSort()
            case .failure:
                self.loadingErrorNFT = true
            }
        }
    }
}
