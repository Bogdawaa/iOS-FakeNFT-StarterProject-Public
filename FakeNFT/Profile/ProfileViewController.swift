//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 25.03.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController{
    //MARK: - UI
    private lazy var profileEditButton: UIButton  = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        self.view.addSubview(button)
        return button
    }()
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pepe")
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
        label.text = "Joaquin Phoenix"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()
    private lazy var profileTextView: UITextView = {
        let textView = UITextView()
        textView.font = .caption1
        textView.isEditable = false
        textView.text = "Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        return textView
    }()
    private lazy var profileHyperlink: UILabel = {
        let label = UILabel()
        label.text = "Joaquin Phoenix.com"
        label.textColor = .systemBlue
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
        self.profileTableView = tableView
        self.view.addSubview(tableView)
        return tableView
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        constraitsProfileEditButton()
        constraitsProfileImage()
        constraitsProfileNameLabel()
        constraitsProfileTextView()
        constraitsProfileHyperlink()
        constraitsProfileTableView()
    }
    //MARK: - constraits
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
//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.Identifier, for: indexPath) as? ProfileTableCell else {
            assertionFailure("")
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0 :
            cell.textLabel?.text = "Мои NFT (122)"
        case 1 :
            cell.textLabel?.text = "Избранные NFT (11)"
        case 2 :
            cell.textLabel?.text = "О разработчике"
        default: ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    

    
}
