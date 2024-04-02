//
//  File.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 30.03.2024.
//
import UIKit
import Foundation

final class MyNFTViewController: UIViewController {
    // MARK: - UI
    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MyNFTTableCell.self, forCellReuseIdentifier: MyNFTTableCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypWhite
        view.addSubview(tableView)
        return tableView
    }()
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navBarSetup()
        setupGestureRecognizers()
        constraitsNftTableView()
    }
    // MARK: - GESTURE SETTING
    private func setupGestureRecognizers() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }

    // MARK: - NAV BAR SETTING
    private func navBarSetup() {
        if let navBar = navigationController?.navigationBar {

            let leftButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(self.dismissButtonClicked)
            )
            leftButton.tintColor = .ypBlack
            navigationItem.leftBarButtonItem = leftButton

            let test = UILabel()
            test.text = "Мои NFT"
            test.font = .bodyBold
            navBar.topItem?.titleView = test

            let rightButton = UIBarButtonItem(
                image: .ypSortButton,
                style: .plain,
                target: self,
                action: #selector(self.sortButtonClicked)
            )
            rightButton.tintColor = .ypBlack
            navigationItem.rightBarButtonItem = rightButton
        }
    }
    // MARK: - Configure Sort Menu
    func configureSortMenu() {
        let priceSortItem = UIAlertAction(title: "По цене", style: .default) { _ in
           // todo
        }
        let ratingSortItem = UIAlertAction(title: "По рейтингу", style: .default) { _ in
           // todo
        }
        let namegSortItem = UIAlertAction(title: "По названию", style: .default) { _ in
           // todo
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        alert.addAction(priceSortItem)
        alert.addAction(ratingSortItem)
        alert.addAction(namegSortItem)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    // MARK: - OBJC
    @objc
    func swipeAction(swipe: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
    }
    @objc
    func dismissButtonClicked() {
        self.dismiss(animated: true)
    }
    @objc
    func sortButtonClicked() {
        configureSortMenu()
    }
    // MARK: - CONSTRAITS
    private func constraitsNftTableView() {
        NSLayoutConstraint.activate([
            nftTableView.topAnchor.constraint(equalTo: view.topAnchor),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
// MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {

}
// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNFTTableCell.identifier,
            for: indexPath
        ) as? MyNFTTableCell
        else {
            return UITableViewCell()
        }
        /*
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Мои NFT (122)"
        case 1:
            cell.textLabel?.text = "Избранные NFT (11)"
        case 2:
            cell.textLabel?.text = "О разработчике"
        default:
            break
        }
        */
        return cell
    }
}
