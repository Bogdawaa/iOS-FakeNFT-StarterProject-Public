import UIKit

protocol ViewWithTable {
    var tableView: UITableView { get set }
    func reload()
    func update(newIndexes: Range<Int>)
}

extension ViewWithTable {
    func reload() {
        tableView.reloadData()
    }

    func update(newIndexes: Range<Int>) {
        if newIndexes.isEmpty { return }
        tableView.performBatchUpdates {
            let indexPaths = newIndexes.map { index in
                IndexPath(row: index, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}
