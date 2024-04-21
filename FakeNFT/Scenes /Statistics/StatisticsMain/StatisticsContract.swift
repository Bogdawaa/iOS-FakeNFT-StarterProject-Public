//
//  StatisticsContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

import Foundation

protocol StatisticsViewProtocol: AnyObject, ErrorView {
    var presenter: StatisticsPresenterProtocol { get set }
    func displayUserCells(_ users: [User])
    func loadingDataStarted()
    func loadingDataFinished()
    func showError(_ model: ErrorModel)
}

protocol StatisticsPresenterProtocol {
    var view: StatisticsViewProtocol? { get set }
    func viewDidLoad()
    func setUsersSortingParametr(_ parametr: SortParametr)
    func loadUsers(with parametr: SortParametr)
    func getSortParametr() -> SortParametr
}
