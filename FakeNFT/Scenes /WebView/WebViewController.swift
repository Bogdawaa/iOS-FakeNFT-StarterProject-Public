//
//  WebViewController.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import WebKit
import ProgressHUD

final class WebViewController: UIViewController {
    private var link: URL

    // MARK: - UiElements

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.ypBackward, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    // MARK: - Initialisation

    init(link: URL) {
        self.link = link
        super.init(nibName: nil, bundle: nil)
        loadWebView(link: link)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lyfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
        navigationBar()
    }

    // MARK: - Actions

    @objc private func backButtonAction() {
        ProgressHUD.dismiss()
        dismiss(animated: true)
    }

    // MARK: - Load Website

    private func loadWebView(link: URL) {
        let request = URLRequest(url: link)
        webView.load(request)
    }

    // MARK: - Private methods

    private func navigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(
                title: "",
                style: .plain,
                target: nil,
                action: nil
            )
        }
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = nil
    }

    private func configViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        view.addSubview(backButton)
        view.addSubview(webView)
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ProgressHUD.show(interaction: false)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
        print("did fail web view error:", error)
    }
}
