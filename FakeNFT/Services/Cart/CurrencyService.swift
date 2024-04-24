//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import Foundation

typealias CurrencyCompletion = (Result<CurrencyModel, Error>) -> Void

protocol CurrencyService {
    func loadCurrencies(completion: @escaping CurrencyCompletion)
}

final class CurrencyServiceImpl: CurrencyService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCurrencies(completion: @escaping CurrencyCompletion) {
        let request = CurrencyRequest(secretInjector: { request in
            return request
        })
        networkClient.send(request: request, type: CurrencyModel.self, onResponse: completion)
    }
}
