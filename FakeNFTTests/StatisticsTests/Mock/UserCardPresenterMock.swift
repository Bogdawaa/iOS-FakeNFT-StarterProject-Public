//
//  UserCardPresenterMock.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 18.04.2024.
//

import Foundation
@testable import FakeNFT

class UserCardPresenterMock: UserCardPresenterProtocol {
    
    var view: FakeNFT.UserCardViewProtocol?
    var viewDidLoadCalled = false
    var setUserCalled = false
    var countUserCalled = false
    var userWebsiteButtonTappedCalled = false
    var presentNftCollectionTappedCalled = false

    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func setUser(with user: FakeNFT.User) {
        setUserCalled = true
    }
    
    func countUserNFTS() -> Int {
        countUserCalled = true
        return 0
    }
    
    func userWebsiteButtonTapped() {
        userWebsiteButtonTappedCalled = true
    }
    
    func presentNftCollectionTapped() {
        presentNftCollectionTappedCalled
    }
    
}
