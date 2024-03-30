//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

final class StatisticsViewController: StatLoggedUIViewController, StatisticsViewProtocol {

    // MARK: - properties
    var presenter: StatisticsPresenterProtocol

    private var isShowing = false

    private lazy var sortButton: UIButton = {
        let btn = UIButton()
        let btnImage = UIImage.ypSort
        btn.tintColor = .ypBlack
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
        control.attributedTitle = NSAttributedString(string: "Statistics.refreshData"~)
        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return control
    }()

    private(set) var users: [User] = []

    // MARK: - init
    init(presenter: StatisticsPresenterProtocol, statlog: StatLog) {
        self.presenter = presenter
        super.init(statLog: statlog)
        self.presenter.view = self
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
        presenter.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isShowing {
            ProgressHUD.dismiss()
        }
    }

    func displayUserCells(_ users: [User]) {
        self.users = users
        statisticsTableView.reloadData()
    }

    func loadingDataStarted() {
        isShowing = true
        ProgressHUD.show()
        statisticsTableView.isUserInteractionEnabled = false
    }

    func loadingDataFinished() {
        isShowing = false
        ProgressHUD.dismiss()
        statisticsTableView.isUserInteractionEnabled = true
    }

    // MARK: - private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(statisticsTableView)
        statisticsTableView.addSubview(refreshControl)
        statisticsTableView.sendSubviewToBack(refreshControl)

        self.navigationController?.navigationBar.tintColor = UIColor.ypBlack
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)

        applyConstraints()
    }

    private func applyConstraints() {
        let statisticsTableViewConstraints = [
            statisticsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statisticsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statisticsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(statisticsTableViewConstraints)
    }

    // MARK: - actions
    @objc
    private func sortButtonTapped() {
        let alert = UIAlertController(
            title: "Statistics.sortAllertTitle"~,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(
                title: "Statistics.sortButton.byName"~,
                style: .default,
                handler: { [weak self] _ in
                    guard let self else { return }
                    presenter.setUsersSortingParametr(SortParametr.byName)
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Statistics.sortButton.byRating"~,
                style: .default,
                handler: { [weak self] _ in
                    guard let self else { return }
                    presenter.setUsersSortingParametr(SortParametr.byRating)
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Statistics.sortButton.close"~,
                style: .cancel
            )
        )
        self.present(alert, animated: true)
    }

    @objc
    func refreshData() {
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
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userCardViewController = ViewBuilder.buildUserCardViewController(with: users[indexPath.row])
        userCardViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(userCardViewController, animated: true)
    }
}
