//
//  WebViewPresenter.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 10.04.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

class WebViewPresenter: WebViewPresenterProtocol {

    // MARK: - properties
    weak var view: WebViewControllerProtocol?

    private var user: User?

    // MARK: - init
    init(user: User) {
        self.user = user
    }

    // MARK: - methods
    func viewDidLoad() {
        guard let user,
         let url = URL(string: user.website) else { return }

        didUpdateProgressValue(0)
        view?.load(request: URLRequest(url: url))
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let progressValue = Float(newValue)
        view?.setProgressValue(progressValue)

        let shouldHideProgress = shouldHideProgress(for: progressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
