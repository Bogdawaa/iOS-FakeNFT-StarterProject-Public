//
//  CartService.swift
//  FakeNFT
//
//  Created by admin on 29.03.2024.
//

import Foundation

typealias CartCompletion = (Result<CartModel, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void

protocol CartService {
    func downloadServiceNFTs(with id: String, completion: @escaping NftsCompletion)
    func updateFromCart(id: String, nftsID: [String], completion: @escaping CartCompletion)
}

final class CartServiceImpl: CartService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func downloadServiceNFTs(with id: String, completion: @escaping NftsCompletion) {

    }

    func updateFromCart(id: String, nftsID: [String], completion: @escaping CartCompletion) {
        let request = CartRequestPut(
            secretInjector: { request in
                return request
            },
            id: id,
            nfts: nftsID
        )
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }

    private func downloadCart(id: String, completion: @escaping CartCompletion) {
        let request = CartRequest(secretInjector: { request in
            return request
        }, id: id)
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }

    private func downloadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self, onResponse: completion)
    }
}
