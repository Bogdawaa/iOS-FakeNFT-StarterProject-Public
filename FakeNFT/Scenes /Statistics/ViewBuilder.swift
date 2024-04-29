//
//  Router.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 18.04.2024.
//

import UIKit

final class ViewBuilder {

    static func buildWebViewController(with user: User) -> WebViewController {
        let webViewPresenter = WebViewPresenter(user: user)
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        return webViewController
    }

    static func buildUserCardViewController(with user: User) -> UserCardViewController {
        let userCardViewController = UserCardViewController(
            presenter: DIContainer().userCardPresenter(),
            statlog: DIContainer().statlog()
        )
        userCardViewController.presenter.setUser(with: user)
        return userCardViewController
    }

    static func buildCollectionNft(with user: User) -> UsersCollectionViewController {
        let usersCollectionNftViewController = UsersCollectionViewController(
            presenter: DIContainer().usersCollectionPresenter(),
            statlog: DIContainer().statlog()
        )
        usersCollectionNftViewController.presenter.setNftsId(nftsId: user.nfts)
        return usersCollectionNftViewController
    }

    static func buildStatisticsViewController() -> StatisticsViewController {
        let statisticsViewController = StatisticsViewController(
            presenter: DIContainer().statisticsPresenter(),
            statlog: DIContainer().statlog()
        )
        return statisticsViewController
    }
}
