//
//  UserCardContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 07.04.2024.
//

import Foundation

protocol UserCardViewProtocol: AnyObject {
    var presenter: UserCardPresenterProtocol { get set }
    func setupUserData(with user: User)
}

protocol UserCardPresenterProtocol {
    var view: UserCardViewProtocol? { get set }
    func viewDidLoad()
    func countUserNFTS() -> Int
    func userWebsiteButtonTapped()
}
