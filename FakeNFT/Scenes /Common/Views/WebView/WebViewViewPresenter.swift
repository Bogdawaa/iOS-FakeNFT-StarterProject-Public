import Foundation

protocol WebViewViewPresenter {
    func viewDidLoad()
    func viewWillAppear()
}

final class WebViewViewPresenterImpl: WebViewViewPresenter {
    weak var view: WebViewView?

    let url: URL

    init(url: URL) {
        self.url = url
    }

    func viewDidLoad() {
        view?.load(URLRequest(url: url))
    }

    func viewWillAppear() {
        view?.willAppear()
    }

    func makeWebViewRequest() -> URLRequest {
        URLRequest(url: url)
    }
}

extension WebViewViewPresenterImpl: WebViewViewDelegat {
    func calculateProgress(for currentValue: Double) -> Progress {
        Progress(from: currentValue)
    }
}
