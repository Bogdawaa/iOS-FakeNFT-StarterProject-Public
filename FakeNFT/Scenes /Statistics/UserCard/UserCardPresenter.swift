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
    private let diContainer = DIContainer()

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
        guard let user else { return }
        let webView = ViewBuilder.buildWebViewController(with: user)
        view?.showView(viewController: webView)
    }

    func presentNftCollectionTapped() {
        guard let user else { return }
        let usersColletionViewController = ViewBuilder.buildCollectionNft(with: user)
        view?.showView(viewController: usersColletionViewController)
    }

    private func setViewModel(user: User) -> User {
        let userViewModel = User(
            id: user.id,
            name: user.name,
            avatar: user.avatar,
            rating: user.rating,
            website: user.website,
            nfts: user.nfts,
            description: user.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        return userViewModel
    }
}
