//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

import Foundation

final class StatisticsPresenter {

    weak var view: StatisticsViewProtocol?

    let users: [String] = ["Alex", "Bill"]
}

extension StatisticsPresenter: StatisticsPresenterProtocol {
    func numberOfRowsInSection() -> Int {
        return users.count
    }
}
