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
    private let presenter: MyNFTPresenterProtocol
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
        constraitsNftTableView()
        setupGestureRecognizers()
        constraitsNftEmptyLabel()
        presenter.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ProgressHUD.dismiss()
        isLoadingSwitch = false
        nftEmptyLabel.isHidden = true
    }
    // MARK: - GESTURE SETTING
    private func setupGestureRecognizers() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    // MARK: - NAV BAR SETUP
    private func navBarSetup() {
        let leftButton = UIBarButtonItem(
            image: .ypChevronLeft,
            style: .plain,
            target: self,
            action: #selector(self.dismissButtonClicked)
        )
        let rightButton = UIBarButtonItem(
            image: .ypSortButton,
            style: .plain,
            target: self,
            action: #selector(self.sortButtonClicked)
        )
        leftButton.tintColor = .ypBlack
        rightButton.tintColor = .ypBlack
        navigationItem.title = "Profile.MyNFT.Title"~
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    // MARK: - Configure Sort Menu
    func configureSortMenu() {
        let priceSortItem = UIAlertAction(title: "Profile.MyNFT.Sort.ByPrice"~, style: .default) { _ in
            self.presenter.sortByPrice()
        }
        let ratingSortItem = UIAlertAction(title: "Profile.MyNFT.Sort.ByRating"~, style: .default) { _ in
            self.presenter.sortByRating()
        }
        let namegSortItem = UIAlertAction(title: "Profile.MyNFT.Sort.ByName"~, style: .default) { _ in
            self.presenter.sortByName()
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
        self.navigationController?.popViewController(animated: true)
        presenter.delegate?.updateProfile()
    }

    @objc
    func dismissButtonClicked() {
        self.navigationController?.popViewController(animated: true)
        presenter.delegate?.updateProfile()
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
        let isLiked = presenter.getLikedNftId().contains(where: {
            $0 == nftSetting.id
        })
        cell.configure(
            nftImageURL: nftSetting.images.first,
            nftTitle: nftSetting.name,
            nftPrice: nftSetting.price,
            nftAuthor: nftSetting.author,
            nftRatingStars: nftSetting.rating,
            nftIsLiked: isLiked,
            nftId: nftSetting.id
        )
        cell.delegate = self
        return cell
    }
}
// MARK: - MyNFTViewProtocol
extension MyNFTViewController: MyNFTViewProtocol {
    func setProfileDelegate(delegate: ProfileViewControllerUpdateNftDelegate) {
        presenter.setProfileDelegate(delegate: delegate)
    }

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

    func setLikedNftId(nftId: [String]) {
        presenter.setLikedNftId(nftId: nftId)
    }
}
// MARK: - MyNFTTableCellDelegate
extension MyNFTViewController: MyNFTTableCellDelegate {
    func setLike(nftId: String) {
        var likedNft = presenter.getLikedNftId()
        likedNft.append(nftId)
        presenter.updateFavoriteNft(nftIds: likedNft)

    }

    func removeLike(nftId: String) {
        var likedNft = presenter.getLikedNftId()
        likedNft.removeAll(where: {
            $0 == nftId
        })
        presenter.updateFavoriteNft(nftIds: likedNft)
    }
}
