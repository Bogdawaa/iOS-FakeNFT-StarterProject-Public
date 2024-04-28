//
//  CartRequest.swift
//  FakeNFT
//
//  Created by admin on 29.03.2024.
//

import Foundation

struct CartRequest: NetworkRequest {
    var httpBody: String?

    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}
