//
//  StatisticsViewControllerMock.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 16.04.2024.
//

import Foundation
@testable import FakeNFT

class StatisticsViewControllerMock: StatisticsViewProtocol {
    
    var presenter: FakeNFT.StatisticsPresenterProtocol
    
    var loadingDataStartedCalled = false
    var loadingDataFinishedCalled = false
    var displayUserCellsCalled = false
    var loadingDataFailedCalled = false

    
    init(presenter: FakeNFT.StatisticsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func displayUserCells(_ users: [FakeNFT.User]) {
        displayUserCellsCalled = true
    }
    
    func loadingDataStarted() {
        loadingDataStartedCalled = true
    }
    
    func loadingDataFinished() {
        loadingDataFinishedCalled = true
    }
    
    func showError(_ model: FakeNFT.ErrorModel) {
        loadingDataFailedCalled = true
    }
}
