//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 10.04.2024.
//

import UIKit
import WebKit

protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol { get set }
    func load(request: URLRequest)
    func setProgressHidden(_ isHidden: Bool)
    func setProgressValue(_ newValue: Float)
}

protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ viewController: WebViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ viewController: WebViewController)
}

class WebViewController: UIViewController {

    var presenter: WebViewPresenterProtocol

    private var estimatedProgressObservation: NSKeyValueObservation?
    private var webView = WKWebView()

    private var progressView: UIProgressView = {
        let view = UIProgressView()
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(presenter: WebViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            estimatedProgressObservation = webView.observe(
                \.estimatedProgress,
                 changeHandler: { [weak self] _, _ in
                     guard let self else { return }
                     self.presenter.didUpdateProgressValue(webView.estimatedProgress)
                 }
            )
        }

    // MARK: - private methods
    private func setupUI() {
        view = webView
        view.addSubview(progressView)

        let progressView = [
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(progressView)
    }
}

// MARK: - WebViewControllerProtocol extension
extension WebViewController: WebViewControllerProtocol {
    func load(request: URLRequest) {
        webView.load(request)
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
        print(newValue)
    }
}
