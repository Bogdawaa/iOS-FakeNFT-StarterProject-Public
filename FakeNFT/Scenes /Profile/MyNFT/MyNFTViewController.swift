//
//  File.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 30.03.2024.
//
import UIKit
import Foundation
import ProgressHUD

final class MyNFTViewController: StatLoggedUIViewController {
    // MARK: - presenter
    var presenter: MyNFTPresenterProtocol
    // MARK: - private properties
    private var isLoadingSwitch = false {
        didSet {
            if isLoadingSwitch == true {
                navigationController?.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                navigationController?.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
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
    private lazy var nftEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.text = "Profile.MyNFT.Empty"~
        label.isHidden = true
        view.addSubview(label)
        return label
    }()
    // MARK: - INIT
    init(statLog: StatLog, presenter: MyNFTPresenterProtocol) {
        self.presenter = presenter
        super.init(statLog: statLog)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navBarSetup()
        setupGestureRecognizers()
        constraitsNftTableView()
        constraitsNftEmptyLabel()
        presenter.viewDidLoad()
        presenter.view = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ProgressHUD.dismiss()
        isLoadingSwitch = false
    }
    // MARK: - GESTURE SETTING
    private func setupGestureRecognizers() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    // MARK: - NAV BAR SETUP
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
            test.text = "Profile.MyNFT.Title"~
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
        let priceSortItem = UIAlertAction(title: "Profile.MyNFT.Sort.ByPrice"~, style: .default) { _ in
           // todo
        }
        let ratingSortItem = UIAlertAction(title: "Profile.MyNFT.Sort.ByRating"~, style: .default) { _ in
           // todo
        }
        let namegSortItem = UIAlertAction(title: "Profile.MyNFT.Sort.ByName"~, style: .default) { _ in
           // todo
        }
        let cancelAction = UIAlertAction(title: "Profile.MyNFT.Sort.Close"~, style: .cancel)
        let alert = UIAlertController(title: "Profile.MyNFT.Sort.Title"~, message: nil, preferredStyle: .actionSheet)
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
    private func constraitsNftEmptyLabel() {
        NSLayoutConstraint.activate([
            nftEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftEmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
// MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {

}
// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let myNftCount = presenter.getMyNft()?.count else { return 0 }
        return myNftCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNFTTableCell.identifier,
            for: indexPath
        ) as? MyNFTTableCell
        else {
            return UITableViewCell()
        }
        guard let nftSetting = presenter.getMyNft()?[indexPath.row] else { return cell}
        cell.configure(
            nftImageURL:
                nftSetting.images
                .first,
            nftTitle:
                nftSetting.name,
            nftPrice:
                nftSetting.price,
            nftAuthor:
                nftSetting.author,
            nftRatingStars: nftSetting.rating
        )
        return cell
    }
}
// MARK: - MyNFTViewProtocol
extension MyNFTViewController: MyNFTViewProtocol {
    func displayMyNft(_ nft: [Nft]) {
        nftTableView.reloadData()
    }
    func loadingDataStarted() {
        ProgressHUD.show()
        isLoadingSwitch = true
    }
    func loadingDataFinished() {
        ProgressHUD.dismiss()
        isLoadingSwitch = false
    }
    func setNftId(nftId: [String]) {
        presenter.setNftId(nftId: nftId)
    }
}
