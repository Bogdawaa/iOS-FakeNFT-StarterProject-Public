//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(with model: AlertModel)
}

final class AlertPresenter {
    private weak var viewControler: UIViewController?

    init(viewControler: UIViewController? = nil) {
        self.viewControler = viewControler
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: nil,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert presenter"

        let actionCancel = UIAlertAction(title: model.buttonTextCancel, style: .default) { _ in
            alert.dismiss(animated: true)
        }

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }

        alert.addAction(actionCancel)
        alert.addAction(action)
        viewControler?.present(alert, animated: true)
    }
}
