import UIKit
import WebKit

protocol WebViewViewDelegat: AnyObject {
    func calculateProgress(for: Double) -> Progress
}

protocol WebViewView: UIView {
    var delegate: WebViewViewDelegat? { get set }
    func load(_ request: URLRequest)
    func willAppear()
}

final class WebViewViewImpl: UIView, WebViewView {

    weak var delegate: WebViewViewDelegat?
    private var observation: NSKeyValueObservation?

    @objc private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "webView"
        view.backgroundColor = .ypWhite
        return view
    }()

    private var progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .ypBlack
        return view
    }()

     init() {
        super.init(frame: .zero)
        backgroundColor = .ypBlack

        addSubview(webView)
        addSubview(progressView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.topAnchor.constraint(equalTo: self.topAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load(_ request: URLRequest) {
        webView.load(request)
    }

    func willAppear() {
        observation = observe(\.webView.estimatedProgress) { [weak self] _, _ in
            self?.updateProgress()
        }
    }

    private func updateProgress() {
        guard let delegate else { return }
        let progress = delegate.calculateProgress(for: webView.estimatedProgress)

        progressView.progress = progress.value
        progressView.isHidden = progress.toHide
    }
}
