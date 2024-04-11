//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import Foundation

final class PaymentViewModel {
    @Observable var currencies: [CurrencyModelElement] = []
    @Observable var successfulPayment: OrderModel?
    @Observable var paymentError: Bool?
    @Observable var errorLoadingCurrencies: Bool?
    private let serviceCurrency: CurrencyService
    private let serviceOrder: OrderService
    private let serviceCart: CartService

    // MARK: - Initialisation

    init(serviceCurrency: CurrencyService, serviceOrder: OrderService, serviceCart: CartService) {
        self.serviceCurrency = serviceCurrency
        self.serviceOrder = serviceOrder
        self.serviceCart = serviceCart
    }

    // MARK: - Methods

    func cartPayment(currencyId: String) {
        didPayButtonTapped(currencyId: currencyId)
    }

    func loadCurrencies() {
        serviceCurrency.loadCurrencies { result in
            switch result {
            case .success(let response):
                self.currencies = response
            case .failure:
                self.errorLoadingCurrencies = true
            }
        }
    }

    // MARK: - Private methods

    private func didPayButtonTapped(currencyId: String) {
        serviceOrder.checkPaymentResult(with: currencyId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paymentResult):
                self.removeCart()
                self.successfulPayment = paymentResult
            case .failure:
                self.paymentError = true
            }
        }
    }

    private func removeCart() {
        let id = "1"
        let nftsID: [String] = []
        serviceCart.updateFromCart(id: id, nftsID: nftsID) {_ in }
    }
}
