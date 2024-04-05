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
            forCellReuseIdentifier: StatisticsTableViewCell.statisticsTableViewCellIdentifier
        )
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Обновить данные")
        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return control
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
        self.users = users
        statisticsTableView.reloadData()
    }

    // MARK: - private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(sortButton)
        view.addSubview(statisticsTableView)
        statisticsTableView.addSubview(refreshControl)
        statisticsTableView.sendSubviewToBack(refreshControl)
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

    @objc func refreshData() {
        DispatchQueue.main.async {
            self.users.removeAll()
            self.statisticsTableView.reloadData()
        }
        let currentSortParam = presenter.getSortParametr()
        presenter.loadUsers(with: currentSortParam)
        refreshControl.endRefreshing()
    }
}

// MARK: - tableView extensions
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableViewCell.statisticsTableViewCellIdentifier,
            for: indexPath
        ) as? StatisticsTableViewCell else { return UITableViewCell() }

        cell.setupCell(with: users[indexPath.row])

        let url = URL(string: users[indexPath.row].avatar)
        cell.userImage.kf.setImage(
            with: url,
            placeholder: nil
        )
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
}
