//
//  Router.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 18.04.2024.
//

import UIKit

final class UserCardRouter {
    private var user: User
    private var userCardViewController: UserCardViewProtocol
    private var webViewPresenter: WebViewPresenter
    private var webViewController: WebViewController

    init(userCardViewController: UserCardViewProtocol, user: User) {
        self.user = user
        self.userCardViewController = userCardViewController
        self.webViewPresenter = WebViewPresenter(user: user)
        self.webViewController = WebViewController(presenter: webViewPresenter)
        self.webViewPresenter.view = webViewController
    }

    func showNextController() {
        userCardViewController.showView(viewController: webViewController)
    }
}
