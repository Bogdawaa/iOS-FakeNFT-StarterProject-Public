//
//  UserCardPresenterTests.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 18.04.2024.
//

import XCTest
@testable import FakeNFT

final class UserCardPresenterTests: XCTestCase {

    var instance: UserCardPresenterProtocol!
    var viewMock: UserCardViewMock!
    let mockUser = User(
        id: "1",
        name: "Name",
        avatar: "Avatar",
        rating: "1",
        website: "website",
        nfts: [],
        description: "zerocoder"
    )
    
    func testViewLoadedFailedIfUserNil() throws {
        // given
        instance = UserCardPresenter()
        viewMock = UserCardViewMock(presenter: instance)
        instance.view = viewMock
        
        // when
        instance.viewDidLoad()
        
        // then
        XCTAssertFalse(viewMock.setupUserDataCalled)
    }
    
    func testSetupUserCalledWhenViewLoaded() throws {
        // given
        instance = UserCardPresenter()
        viewMock = UserCardViewMock(presenter: instance)
        instance.view = viewMock
        instance.setUser(with: mockUser)
        
        // when
        instance.viewDidLoad()
        
        // then
        XCTAssertTrue(viewMock.setupUserDataCalled)
    }
    
    func testCountUserNFTS() throws {
        // given
        instance = UserCardPresenter()
        viewMock = UserCardViewMock(presenter: instance)
        instance.setUser(with: mockUser)
        instance.view = viewMock
        
        // when
        let countUsers = instance.countUserNFTS()
        
        // then
        XCTAssertEqual(countUsers, 1)
    }
    
}
