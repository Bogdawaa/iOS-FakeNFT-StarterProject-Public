//
//  StatisticsContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

import Foundation

protocol StatisticsViewProtocol: AnyObject {
    var presenter: StatisticsPresenterProtocol { get set }
}

protocol StatisticsPresenterProtocol {
    var view: StatisticsViewProtocol? { get set }
    var users: [String] { get }

    func numberOfRowsInSection() -> Int
}
