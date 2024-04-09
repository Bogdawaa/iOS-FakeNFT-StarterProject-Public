//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let currencyId: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/1")
    }
}
