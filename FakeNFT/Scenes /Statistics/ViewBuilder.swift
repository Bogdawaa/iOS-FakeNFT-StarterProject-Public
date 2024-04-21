//
//  Router.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 18.04.2024.
//

import UIKit

protocol Builder {
    static func buildWebViewController(with user: User) -> UIViewController
}

final class ViewBuilder: Builder {

    static func buildWebViewController(with user: User) -> UIViewController {
        let webViewPresenter = WebViewPresenter(user: user)
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        return webViewController
    }

    static func buildUserCardViewController(with user: User) -> UIViewController {
        let userCardViewController = DIContainer().userCard()
        userCardViewController.presenter.setUser(with: user)
        userCardViewController.presenter.view = userCardViewController
        return userCardViewController
    }

    static func buildCollectionNft(with user: User) -> UIViewController {
        let usersCollectionNftViewController = DIContainer().usersCollectionNftController()
        usersCollectionNftViewController.presenter.view = usersCollectionNftViewController
        usersCollectionNftViewController.presenter.setNftsId(nftsId: user.nfts)
        return usersCollectionNftViewController
    }
}
