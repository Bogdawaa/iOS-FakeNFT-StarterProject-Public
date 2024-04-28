//
//  UserCardContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 07.04.2024.
//

import UIKit

protocol UserCardViewProtocol: AnyObject {
    var presenter: UserCardPresenterProtocol { get set }
    func showView(viewController: UIViewController)
    func setupUserData(with user: User)
}
