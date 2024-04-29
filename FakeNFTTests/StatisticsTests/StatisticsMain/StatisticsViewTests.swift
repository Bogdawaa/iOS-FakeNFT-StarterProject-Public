//
//  StatisticsViewTests.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 17.04.2024.
//

import XCTest
@testable import FakeNFT

final class StatisticsViewTests: XCTestCase {

    var presenterMock: StatisticsPresenterMock!
    var instance: StatisticsViewController!
    var statlogMock: StatLog!
    
    
    func testDisplayUserCells() throws {
        // given
        presenterMock = StatisticsPresenterMock()
        statlogMock = StatlogMock()
        instance = StatisticsViewController(presenter: presenterMock, statlog: statlogMock)
        presenterMock.view = instance
        
        // when
        instance.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(presenterMock.viewDidLoadCalled)
        XCTAssertTrue(presenterMock.loadUsersCalled)
        XCTAssertEqual(instance.users.count, 2)
    }
}
