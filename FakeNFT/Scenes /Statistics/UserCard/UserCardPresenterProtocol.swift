//
//  UserCardPresenterProtocol.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 25.04.2024.
//

import UIKit

protocol UserCardPresenterProtocol {
    var view: UserCardViewProtocol? { get set }
    func viewDidLoad()
    func setUser(with user: User)
    func countUserNFTS() -> Int
    func userWebsiteButtonTapped()
    func presentNftCollectionTapped()
}
