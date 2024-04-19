//
//  OrderService.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import Foundation

typealias OrderCompletion = (Result<OrderModel, Error>) -> Void

protocol OrderService {
    func checkPaymentResult(with currencyId: String, completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func checkPaymentResult(with currencyId: String, completion: @escaping OrderCompletion) {
        let request = OrderRequest(secretInjector: { request in
            // Здесь можно модифицировать request по необходимости
            return request
        }, currencyId: currencyId)
        networkClient.send(request: request, type: OrderModel.self, onResponse: completion)
    }
}
