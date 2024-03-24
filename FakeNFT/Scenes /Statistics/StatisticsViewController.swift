//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

import UIKit

final class StatisticsViewController: UIViewController, StatisticsViewProtocol {

    // MARK: - properties
    var presenter: StatisticsPresenterProtocol

    private lazy var sortButton: UIButton = {
        let btn = UIButton()
        let btnImage = UIImage(named: "sortButton")
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

    // MARK: - init
    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        statisticsTableView.delegate = self
        statisticsTableView.dataSource = self

        presenter.view = self
        setupUI()
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
        // TODO:
    }
}

// MARK: - tableView extensions
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? StatisticsTableViewCell else { return UITableViewCell() }

        cell.setupCell(rank: indexPath.row, name: presenter.users[indexPath.row], score: "1")
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
