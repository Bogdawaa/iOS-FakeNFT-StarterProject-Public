//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 25.03.2024.
//

import Foundation
import UIKit
import ProgressHUD
import Kingfisher

final class ProfileViewController: StatLoggedUIViewController {
    // MARK: - presenter
    var presenter: ProfilePresenterProtocol
    // MARK: - private properties
    private var isLoadingSwitch = false {
        didSet {
            if isLoadingSwitch == true {
                profileTableView.allowsSelection = false
                profileEditButton.isEnabled = false
            } else {
                profileTableView.allowsSelection = true
                profileEditButton.isEnabled = true
            }
        }
    }
    // MARK: - UI
    private lazy var profileEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(profileEditButtonClicked), for: .touchDown)
        self.view.addSubview(button)
        return button
    }()
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ypProfileImage
        imageView.layer.cornerRadius = 70 / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        return imageView
    }()
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        // label.text = "Joaquin Phoenix"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()
    private lazy var profileTextView: UITextView = {
        let textView = UITextView()
        textView.font = .caption1
        textView.isEditable = false
        textView.backgroundColor = .ypWhite
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        return textView
    }()
    private lazy var profileHyperlink: UILabel = {
        let label = UILabel()
       // label.text = "Joaquin Phoenix.com"
        label.textColor = .ypBlueUniversal
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        return label
    }()
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ProfileTableCell.self, forCellReuseIdentifier: ProfileTableCell.Identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ypWhite
        self.profileTableView = tableView
        self.view.addSubview(tableView)
        return tableView
    }()
    // MARK: - init
    init(presenter: ProfilePresenterProtocol, statlog: StatLog) {
        self.presenter = presenter
        super.init(statLog: statlog)
    }
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        constraitsProfileEditButton()
        constraitsProfileImage()
        constraitsProfileNameLabel()
        constraitsProfileTextView()
        constraitsProfileHyperlink()
        constraitsProfileTableView()
        presenter.view = self
        presenter.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ProgressHUD.dismiss()
        isLoadingSwitch = false
    }
    // MARK: - OBJC

    @objc
    private func profileEditButtonClicked(_ sender: UIButton) {
        let view = EditProfileViewController()
        self.present(view, animated: true)
    }
    // MARK: - private
    private func switchUiAccess () {
    }
    // MARK: - constraits
    private func constraitsProfileEditButton() {
        NSLayoutConstraint.activate([
            profileEditButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            profileEditButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            profileEditButton.widthAnchor.constraint(equalToConstant: 42),
            profileEditButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    private func constraitsProfileImage() {
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: profileEditButton.bottomAnchor, constant: 20)
        ])
    }
    private func constraitsProfileNameLabel() {
        NSLayoutConstraint.activate([
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            profileNameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 21)
        ])
    }
    private func constraitsProfileTextView() {
        NSLayoutConstraint.activate([
            profileTextView.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            profileTextView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            profileTextView.trailingAnchor.constraint(equalTo: profileEditButton.trailingAnchor),
            profileTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    private func constraitsProfileHyperlink() {
        NSLayoutConstraint.activate([
            profileHyperlink.topAnchor.constraint(equalTo: profileTextView.bottomAnchor, constant: 8),
            profileHyperlink.leadingAnchor.constraint(equalTo: profileTextView.leadingAnchor)
        ])
    }
    private func constraitsProfileTableView() {
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: profileHyperlink.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileTableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }

}
func createProfileViewController() -> UINavigationController {
    let myNFTViewController = MyNFTViewController()
    return UINavigationController(rootViewController: myNFTViewController)
}
func createFavoritesNFTViewController() -> UINavigationController {
    let myNFTViewController = FavoritesNFTViewController()
    return UINavigationController(rootViewController: myNFTViewController)

}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let view = createProfileViewController()
            view.modalPresentationStyle = .fullScreen

            present(view, animated: true)
        }
        if indexPath.row == 1 {
            let view = createFavoritesNFTViewController()
            view.modalPresentationStyle = .fullScreen

            present(view, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableCell.Identifier,
            for: indexPath
        ) as? ProfileTableCell else {
            assertionFailure("")
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Profile.myNFT"~
        case 1:
            cell.textLabel?.text = "Profile.favoritesNFT"~
        case 2:
            cell.textLabel?.text = "Profile.aboutDeveloper"~
        default:
            break
        }
        cell.backgroundColor = .ypWhite
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

}
// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func displayProfile(_ profile: Profile) {
        profileNameLabel.text = profile.name
        profileTextView.text = profile.description
        profileHyperlink.text = profile.website
        let url = URL(string: profile.avatar)
        profileImage.kf.setImage(
            with: url
        )
    }
    func loadingDataStarted() {
        ProgressHUD.show()
        isLoadingSwitch = true
    }
    func loadingDataFinished() {
        ProgressHUD.dismiss()
        isLoadingSwitch = false
    }
}
