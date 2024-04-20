//
//  Router.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 18.04.2024.
//

import UIKit

// final class UserCardRouter {
//    private var user: User
//    private var userCardViewController: UserCardViewProtocol
//    private var webViewPresenter: WebViewPresenter
//    private var webViewController: WebViewController
//
//    init(userCardViewController: UserCardViewProtocol, user: User) {
//        self.user = user
//        self.userCardViewController = userCardViewController
//        self.webViewPresenter = WebViewPresenter(user: user)
//        self.webViewController = WebViewController(presenter: webViewPresenter)
//        self.webViewPresenter.view = webViewController
//    }
//
//    func showNextController() {
//        userCardViewController.showView(viewController: webViewController)
//    }
// }

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
}
