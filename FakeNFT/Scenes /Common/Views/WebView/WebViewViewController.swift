import WebKit
import UIKit

final class WebViewViewController: UIViewController {
    private let contentView: WebViewView
    private let presenter: WebViewViewPresenter

    init(presenter: WebViewViewPresenter, contentView: WebViewView) {
        self.presenter = presenter
        self.contentView = contentView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
        super.viewWillAppear(animated)
    }
}
