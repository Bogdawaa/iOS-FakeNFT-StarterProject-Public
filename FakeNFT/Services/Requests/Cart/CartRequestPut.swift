//
//  CartRequestPut.swift
//  FakeNFT
//
//  Created by admin on 31.03.2024.
//

import Foundation

struct CartRequestPut: NetworkRequest {
    var httpBody: String?

    let id: String
    let nfts: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
    var httpMethod: HttpMethod {
        .put
    }
    var dto: Encodable? {
        var components = URLComponents()
        components.queryItems = []
        for nft in nfts {
            let nftQueryItem = URLQueryItem(name: "nfts", value: nft)
            components.queryItems?.append(nftQueryItem)
        }
        let idQueryItem = URLQueryItem(name: "id", value: id)
        components.queryItems?.append(idQueryItem)
        return components.query
    }
}
