import UIKit

protocol CatalogViewDelegate: AnyObject {
    var numberOfRows: Int { get }

    func rowData(at indexPath: IndexPath) -> CatalogRowData?
    func didSelectRow(at indexPath: IndexPath)
}

final class CatalogView: UIView {
    weak var delegate: CatalogViewDelegate?

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        view.tableHeaderView = UIView()
        view.separatorColor = .clear

        view.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
        view.dataSource = self
        view.delegate = self

        return view
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .ypWhite

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CatalogView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.numberOfRows ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogCell.reuseIdentifier,
            for: indexPath
        ) as? CatalogCell

        guard
            let cell,
            let delegate,
            let rowData = delegate.rowData(at: indexPath)
        else { return UITableViewCell() }

        cell.initData(rowData: rowData)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}

extension CatalogView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 179 }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CatalogCell else { return }
        cell.resizeImage()
    }

}
