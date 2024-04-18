//
//  UserCardViewMock.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 18.04.2024.
//

import UIKit
@testable import FakeNFT

class UserCardViewMock: UserCardViewProtocol {
    
    var presenter: FakeNFT.UserCardPresenterProtocol
    var showViewCalled = false
    var setupUserDataCalled = false
    
    init(presenter: FakeNFT.UserCardPresenterProtocol) {
        self.presenter = presenter
    }
    
    func showView(viewController: UIViewController) {
        showViewCalled = true
    }
    
    func setupUserData(with user: FakeNFT.User) {
        setupUserDataCalled = true
    }
    
    
}
