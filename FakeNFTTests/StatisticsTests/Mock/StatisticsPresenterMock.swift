//
//  StatisticsPresenterMock.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 17.04.2024.
//

import Foundation
@testable import FakeNFT

class StatisticsPresenterMock: StatisticsPresenterProtocol {
    
    var view: FakeNFT.StatisticsViewProtocol?
    var viewDidLoadCalled = false
    var setUsersSortingParametrCalled = false
    var loadUsersCalled = false
    var getSortParametrCalled = false

    
    func viewDidLoad() {
        viewDidLoadCalled = true
        loadUsers(with: SortParametr.byName)
    }
    
    func setUsersSortingParametr(_ parametr: FakeNFT.SortParametr) {
        setUsersSortingParametrCalled = true
    }
    
    func loadUsers(with parametr: FakeNFT.SortParametr) {
        loadUsersCalled = true
        
        let serviceMock = ServiceMock()
        serviceMock.loadUsers(with: parametr) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let users):
                self.view?.loadingDataFinished()
                self.view?.displayUserCells(users)
            }
        }
    }
    
    func getSortParametr() -> FakeNFT.SortParametr {
        getSortParametrCalled = true
        return SortParametr.byName
    }
    
    
}
