//
//  CurrencyRequest.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import Foundation

struct CurrencyRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
