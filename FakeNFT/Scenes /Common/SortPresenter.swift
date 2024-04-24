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
            title: "Sort.Alert.Sorting"~,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.view.accessibilityIdentifier = "Sort presenter"

        let priceAction = UIAlertAction(
            title: "Sort.Alert.Sorting"~,
            style: .default
        ) { _ in
                model.completionPrice?()
        }
        let ratingAction = UIAlertAction(
            title: "Sort.Alert.Sorting"~,
            style: .default
        ) { _ in
                model.completionRating?()
        }
        let nameAction = UIAlertAction(
            title: "Sort.Alert.Sorting"~,
            style: .default
        ) { _ in
                model.completionName?()
        }
        let actionCancel = UIAlertAction(
            title: "Sort.Alert.Sorting"~,
            style: .cancel
        ) { _ in
                alert.dismiss(animated: true)
        }

        alert.addAction(priceAction)
        alert.addAction(ratingAction)
        alert.addAction(nameAction)
        alert.addAction(actionCancel)

        viewControler?.present(alert, animated: true, completion: nil)
    }
}
