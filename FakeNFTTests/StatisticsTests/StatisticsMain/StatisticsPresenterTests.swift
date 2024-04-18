//
//  StatisticsPresenterTests.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 16.04.2024.
//

import XCTest
@testable import FakeNFT

final class StatisticsPresenterTests: XCTestCase {

    var instance: StatisticsPresenterProtocol!
    var viewMock: StatisticsViewControllerMock!
    var serviceMock: ServiceMock!

    func testViewDidLoad() throws {
        // given
        serviceMock = ServiceMock()
        instance = StatisticsPresenter(service: serviceMock)
        viewMock = StatisticsViewControllerMock(presenter: instance)
        instance.view = viewMock
        
        // when
        instance.viewDidLoad()

        // then
        XCTAssertTrue(serviceMock.loadUsersCalled)
    }
    
    func testLoadUsersFailed() {
        // given
        serviceMock = ServiceMock()
        instance = StatisticsPresenter(service: serviceMock)
        viewMock = StatisticsViewControllerMock(presenter: instance)
        instance.view = viewMock
        let parametr = SortParametr.byName
        
        // when
        serviceMock.loadUsersFailed = true
        instance.loadUsers(with: parametr)

        // then
        XCTAssertTrue(viewMock.loadingDataFailedCalled)
    }
}
