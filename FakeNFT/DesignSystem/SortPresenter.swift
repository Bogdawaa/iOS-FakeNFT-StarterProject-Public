//
//  SortPresenter.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import UIKit

protocol SortPresenterProtocol: AnyObject {
    func showSort(with model: SortModel)
}

final class SortPresenter {
    private weak var viewControler: UIViewController?

    init(viewControler: UIViewController? = nil) {
        self.viewControler = viewControler
    }
}

extension SortPresenter: SortPresenterProtocol {
    func showSort(with model: SortModel) {
        let alert = UIAlertController(
            title: NSLocalizedString("Sort.Alert.Sorting", comment: ""),
            message: nil,
            preferredStyle: .actionSheet)
        alert.view.accessibilityIdentifier = "Sort presenter"

        let priceAction = UIAlertAction(
            title: NSLocalizedString("Sort.Alert.Price", comment: ""),
            style: .default) { _ in
            model.completionPrice?()
        }
        let ratingAction = UIAlertAction(
            title: NSLocalizedString("Sort.Alert.Rating", comment: ""),
            style: .default) { _ in
            model.completionRating?()
        }
        let nameAction = UIAlertAction(
            title: NSLocalizedString("Sort.Alert.Name", comment: ""),
            style: .default) { _ in
            model.completionName?()
        }
        let actionCancel = UIAlertAction(
            title: NSLocalizedString("Sort.Alert.Close", comment: ""),
            style: .cancel) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(priceAction)
        alert.addAction(ratingAction)
        alert.addAction(nameAction)
        alert.addAction(actionCancel)

        viewControler?.present(alert, animated: true, completion: nil)
    }
}
