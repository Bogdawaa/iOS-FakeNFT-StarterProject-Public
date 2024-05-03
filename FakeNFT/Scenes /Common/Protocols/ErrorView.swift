import UIKit

struct ErrorModel {
    let message: String
    let actionText: String
    let action: () -> Void

    init(message: String, actionText: String = "Error.repeat"~, action: @escaping () -> Void) {
        self.message = message
        self.actionText = actionText
        self.action = action
    }
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        let title = NSLocalizedString("Error.title", comment: "")
        let alert = UIAlertController(
            title: title,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: model.actionText, style: UIAlertAction.Style.default) {_ in
            model.action()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
