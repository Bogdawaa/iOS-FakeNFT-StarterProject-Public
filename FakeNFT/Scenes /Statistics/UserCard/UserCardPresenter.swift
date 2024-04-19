//
//  UserCardPresenter.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 07.04.2024.
//

import Foundation

final class UserCardPresenter: UserCardPresenterProtocol {

    weak var view: UserCardViewProtocol?
    private(set) var user: User?


    func viewDidLoad() {
        guard let user else { return }
        let userViewModel = setViewModel(user: user)
        view?.setupUserData(with: userViewModel)
    }

    func setUser(with user: User) {
        self.user = user
    }

    func countUserNFTS() -> Int {
        return user?.nfts.count ?? 0
    }

    func userWebsiteButtonTapped() {
        guard let user,
        let view else { return }
        let router = UserCardRouter(userCardViewController: view, user: user)
        router.showNextController()
    }

    private func setViewModel(user: User) -> User {
        let userViewModel = User(
            id: user.id,
            name: user.name,
            avatar: user.avatar,
            rating: user.rating,
            website: user.website,
            nfts: user.nfts,
            description: user.description.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        return userViewModel
    }
}
