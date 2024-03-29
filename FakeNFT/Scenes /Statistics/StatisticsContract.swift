//
//  StatisticsContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

import Foundation

protocol StatisticsViewProtocol: AnyObject {
    var presenter: StatisticsPresenterProtocol { get set }
    func displayUserCells(_ users: [User])
}

protocol StatisticsPresenterProtocol {
    var view: StatisticsViewProtocol? { get set }
    func viewDidLoad()
    func setUsersSortingParametr(_ parametr: SortParametr)
}
