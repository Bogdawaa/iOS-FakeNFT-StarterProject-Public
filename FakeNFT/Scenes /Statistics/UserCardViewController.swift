//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 07.04.2024.
//

import UIKit
import Kingfisher

final class UserCardViewController: StatLoggedUIViewController {

    var presenter: UserCardPresenterProtocol

    private lazy var stackView: UIStackView = {
        let stv = UIStackView()
        stv.translatesAutoresizingMaskIntoConstraints = false
        return stv
    }()

    private lazy var userInfoView: UIView = {
        let stv = UIView()
        stv.translatesAutoresizingMaskIntoConstraints = false
        return stv
    }()

    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        lbl.textColor = UIColor.label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var userDesciptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = UIColor.label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var userWebsiteButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.ypBlackUniversal.cgColor
        btn.backgroundColor = .systemBackground
        btn.addTarget(self, action: #selector(userWebsiteButtonTapped), for: .touchUpInside)
        btn.setTitle("Перейти на сайт пользователя", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        btn.setTitleColor(UIColor.label, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var userCollectionNftTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "collectionNFTCell")
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: - init
    init(presenter: UserCardPresenterProtocol, statlog: StatLog) {
        self.presenter = presenter
        super.init(statLog: statlog)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        userCollectionNftTableView.dataSource = self

        setupUI()
        presenter.viewDidLoad()

        // userImageView
        userImageView.layoutIfNeeded()
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
    }

    // MARK: - private methods
    private func setupUI() {

        // view
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)

        // stackView
        stackView.addSubview(userInfoView)
        stackView.addSubview(userDesciptionLabel)
        stackView.addSubview(userWebsiteButton)
        stackView.addSubview(userCollectionNftTableView)

        // userInfoView
        userInfoView.addSubview(userImageView)
        userInfoView.addSubview(userNameLabel)

        // constraints
        applyConstraints()
    }

    private func applyConstraints() {
        stackView.constraintEdges(to: view)

        let userInfoViewConstraints = [
            userInfoView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            userInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userInfoView.heightAnchor.constraint(equalTo: userImageView.heightAnchor)
        ]
        let userImageViewConstraints = [
            userImageView.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 16),
            userImageView.topAnchor.constraint(equalTo: userInfoView.topAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.widthAnchor.constraint(equalToConstant: 70)
        ]
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor)
        ]
        let userDesriptionLabelConstraints = [
            userDesciptionLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            userDesciptionLabel.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 16),
            userDesciptionLabel.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor, constant: -18),
            userDesciptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
        ]
        let userWebsiteButtonConstraints = [
            userWebsiteButton.topAnchor.constraint(equalTo: userDesciptionLabel.bottomAnchor, constant: 28),
            userWebsiteButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            userWebsiteButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            userWebsiteButton.heightAnchor.constraint(equalToConstant: 40)
        ]

        let userCollectionNftTableViewConstraints = [
            userCollectionNftTableView.topAnchor.constraint(equalTo: userWebsiteButton.bottomAnchor, constant: 40),
            userCollectionNftTableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            userCollectionNftTableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            userCollectionNftTableView.heightAnchor.constraint(equalToConstant: 54)
        ]
        NSLayoutConstraint.activate(userInfoViewConstraints)
        NSLayoutConstraint.activate(userImageViewConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(userDesriptionLabelConstraints)
        NSLayoutConstraint.activate(userWebsiteButtonConstraints)
        NSLayoutConstraint.activate(userCollectionNftTableViewConstraints)
    }

    // MARK: - actions
    @objc
    func userWebsiteButtonTapped() {
        presenter.userWebsiteButtonTapped()
    }
}

// MARK: - UserCardViewProtocol extension
extension UserCardViewController: UserCardViewProtocol {
    func setupUserData(with user: User) {
        self.userNameLabel.text = user.name
        self.userDesciptionLabel.text = user.description

        let url = URL(string: user.avatar)
        self.userImageView.kf.setImage(
            with: url,
            placeholder: UIImage.ypUserPlaceholder
        )
    }

    func showView(viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource extension
extension UserCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Коллекция NFT (\(presenter.countUserNFTS()))"
        return cell
    }
}
