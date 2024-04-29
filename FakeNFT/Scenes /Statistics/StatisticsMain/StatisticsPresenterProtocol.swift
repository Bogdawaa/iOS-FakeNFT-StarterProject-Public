//
//  StatisticsPresenterProtocol.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 25.04.2024.
//

import UIKit

protocol StatisticsPresenterProtocol {
    var view: StatisticsViewProtocol? { get set }
    func viewDidLoad()
    func setUsersSortingParametr(_ parametr: SortParametr)
    func loadUsers(with parametr: SortParametr)
    func getSortParametr() -> SortParametr
}
