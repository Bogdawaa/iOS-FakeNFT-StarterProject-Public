//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

import UIKit
import Kingfisher

final class StatisticsViewController: StatLoggedUIViewController, StatisticsViewProtocol {

    // MARK: - properties
    var presenter: StatisticsPresenterProtocol
    var isEndReached = false

    private lazy var sortButton: UIButton = {
        let btn = UIButton()
        let btnImage = UIImage.ypSort
        btn.setImage(btnImage, for: .normal)
        btn.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let statisticsTableView: UITableView = {
        let table = UITableView()
        table.register(
            StatisticsTableViewCell.self,
            forCellReuseIdentifier: StatisticsTableViewCell.reuseIdentifier
        )
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private var users: [User] = []

    // MARK: - init
    init(presenter: StatisticsPresenterProtocol, statlog: StatLog) {
        self.presenter = presenter
        super.init(statLog: statlog)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        statisticsTableView.delegate = self
        statisticsTableView.dataSource = self

        setupUI()
        presenter.view = self
        presenter.viewDidLoad()

    }

    func displayUserCells(_ users: [User]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.users.append(contentsOf: users)
            // TODO: разобраться с сортировкой пользователей
//            self.users.sort { $0.nfts.count < $1.nfts.count }
            statisticsTableView.reloadData()
        }
    }

    // MARK: - private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(sortButton)
        view.addSubview(statisticsTableView)
        applyConstraints()
    }

    private func applyConstraints() {
        let sortButtonConstraints = [
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ]
        let statisticsTableViewConstraints = [
            statisticsTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            statisticsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statisticsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(sortButtonConstraints)
        NSLayoutConstraint.activate(statisticsTableViewConstraints)
    }

    @objc private func sortButtonTapped() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(
                title: "По имени",
                style: .default,
                handler: { [weak self] _ in
                    guard let self else { return }
                    presenter.setUsersSortingParametr(SortParametr.byName)
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "По рейтингу",
                style: .default,
                handler: { [weak self] _ in
                    guard let self else { return }
                    presenter.setUsersSortingParametr(SortParametr.byRating)
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Закрыть",
                style: .cancel
            )
        )
        self.present(alert, animated: true)
    }

    func updateTableViewAnimated(indexes: Range<Int>) {
            statisticsTableView.performBatchUpdates {
                let indexPath = indexes.map { item in
                    IndexPath(row: item, section: 0)
                }
                statisticsTableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in
            }
    }
}

// MARK: - tableView extensions
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? StatisticsTableViewCell else { return UITableViewCell() }

        cell.setupCell(with: users[indexPath.row])

        let url = URL(string: users[indexPath.row].avatar)
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        cell.userImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [.processor(processor)]
        ) { _ in
                tableView.reloadRows(
                    at: [indexPath],
                    with: .automatic
                )
        }
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: останавливать загрузку если новые записи не добавляются
        let usersCount = users.count
        if indexPath.row + 1 == usersCount && !isEndReached {
            presenter.loadUsers(with: presenter.getSortParametr())
            let newUserCount = users.count
            if usersCount != newUserCount {
                updateTableViewAnimated(indexes: usersCount..<newUserCount)
            }
        }
    }
}
