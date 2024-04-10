//
//  UserCardPresenter.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 07.04.2024.
//

import Foundation

final class UserCardPresenter: UserCardPresenterProtocol {

    weak var view: UserCardViewProtocol?

    private var user: User?

    func viewDidLoad() {
        guard let user else { return }
        view?.setupUserData(with: user)
    }

    func setUser(with user: User) {
        self.user = user
    }

    func countUserNFTS() -> Int {
        return user?.nfts.count ?? 0
    }

    func userWebsiteButtonTapped() {
        // TODO: 
    }
}
