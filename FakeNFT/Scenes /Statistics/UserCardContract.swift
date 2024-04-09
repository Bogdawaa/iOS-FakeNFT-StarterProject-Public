//
//  UserCardContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 07.04.2024.
//

import Foundation

protocol UserCardViewProtocol: AnyObject {
    var presenter: UserCardPresenterProtocol { get set }
    func setUser(user: User)
}

protocol UserCardPresenterProtocol {
    var view: UserCardViewProtocol? { get set }
    func viewDidLoad()
//    func setupUserCard(with user: User)
}
