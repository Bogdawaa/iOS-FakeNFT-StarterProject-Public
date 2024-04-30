//
//  AboutDeveloperViewController.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 17.04.2024.
//

import Foundation
import UIKit
import WebKit

final class AboutDeveloperViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    // MARK: - UI
    private var webView = WKWebView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchWeb()
    }
}
private extension AboutDeveloperViewController {
    // MARK: - Setup Views
    func setupViews() {
        self.view.addSubview(webView)
        view.backgroundColor = .ypWhite
        webView.backgroundColor = .ypWhite
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    // MARK: - Network
    func fetchWeb() {
        if let url = URL(string: "https://support.apple.com/ru-ru") {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            assertionFailure("Failed to fetch WebView")
        }
    }
}
