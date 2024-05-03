import UIKit

struct SortOption {
    let title: String
    let handler: () -> Void
}

protocol SortableView {
    func selectOrder(sortOptions: [SortOption])
}

extension SortableView where Self: UIViewController {
    func selectOrder(sortOptions: [SortOption]) {
        let alert = UIAlertController(
            title: "SortableView.Sort"~,
            message: nil,
            preferredStyle: .actionSheet
        )

        sortOptions.forEach { option in
            alert.addAction(
                UIAlertAction(
                    title: option.title,
                    style: .default,
                    handler: { _ in option.handler() }
                )
            )
        }

        alert.addAction(
            UIAlertAction(
                title: "SortableView.Close"~,
                style: .cancel
            )
        )

        present(alert, animated: true)
    }
}
