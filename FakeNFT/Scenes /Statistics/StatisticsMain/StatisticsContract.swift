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
    func loadingDataStarted()
    func loadingDataFinished()
    func loadingDataFailed(message: String)
}

protocol StatisticsPresenterProtocol {
    var view: StatisticsViewProtocol? { get set }
    func viewDidLoad()
    func setUsersSortingParametr(_ parametr: SortParametr)
    func loadUsers(with parametr: SortParametr)
    func getSortParametr() -> SortParametr
}
