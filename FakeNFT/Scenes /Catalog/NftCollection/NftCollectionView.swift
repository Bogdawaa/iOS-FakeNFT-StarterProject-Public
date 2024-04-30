import UIKit

protocol NftCollectionViewDelegate: AnyObject {
    var numberOfRows: Int { get }

    func rowData(at indexPath: IndexPath) -> NftCollection?
    func didSelectRow(at indexPath: IndexPath)
    func loadMoreRows()
}

final class NftCollectionView: UIView, LoadingView, ViewWithTable {
    weak var delegate: NftCollectionViewDelegate?

    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .ypBlack
        return view
    }()

    internal lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        view.tableHeaderView = UIView()
        view.separatorColor = .clear

        view.register(NftCollectionCell.self, forCellReuseIdentifier: NftCollectionCell.reuseIdentifier)
        view.dataSource = self
        view.delegate = self

        return view
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .ypWhite

        addSubview(tableView)

        addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: self)

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

extension NftCollectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.numberOfRows ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NftCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? NftCollectionCell

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

extension NftCollectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 179 }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? NftCollectionCell else { return }
        cell.resizeImage()

        guard let delegate else { return }

        if indexPath.row == delegate.numberOfRows - 1 {
            delegate.loadMoreRows()
        }
    }
}
