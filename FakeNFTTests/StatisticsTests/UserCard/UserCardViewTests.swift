//
//  UserCardViewTests.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 18.04.2024.
//

import XCTest
@testable import FakeNFT

final class UserCardViewTests: XCTestCase {

    var statlogMock: StatlogMock!
    var view: UserCardViewController!
    var presenterMock: UserCardPresenterMock!
    
    func testViewDidLoadCalled() throws {
        
        // given
        statlogMock = StatlogMock()
        presenterMock = UserCardPresenterMock()
        view = UserCardViewController(presenter: presenterMock, statlog: statlogMock)
        presenterMock.view = view
        
        // when
        view.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(presenterMock.viewDidLoadCalled)
    }
}
