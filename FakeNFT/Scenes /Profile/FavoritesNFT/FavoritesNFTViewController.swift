//
//  favoritesNFTViewController.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 02.04.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class FavoritesNFTViewController: StatLoggedUIViewController {
    // MARK: - presenter
    var presenter: FavoriteNFTPresenterProtocol
    // MARK: - profile delegate
    weak var delegate: ProfileViewControllerUpdateNftDelegate?
    // MARK: - PRIVATE PROPERTIES
    private var isLoadingSwitch = false {
        didSet {
            if isLoadingSwitch == true {
            } else {
            }
        }
    }
    // MARK: - UI
    private lazy var favoritesNftCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            FavoritesNFTCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoritesNFTCollectionViewCell.favoritesNftCellIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .ypWhite
        self.view.addSubview(collectionView)
        self.favoritesNftCollectionView = collectionView
        return collectionView
    }()
    private lazy var favoritesNftEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.text = "Profile.favoritesNFT.Empty"~
        view.addSubview(label)
        return label
    }()
    // MARK: - INIT
    init( statLog: StatLog, presenter: FavoriteNFTPresenterProtocol) {
        self.presenter = presenter
        super.init(statLog: statLog)
    }
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navbarSetup()
        setupGestureRecognizers()
        constraitsFavoritesNftCollectionView()
        presenter.view = self
        presenter.viewDidLoad()
        constraitsFavoritesNftEmptyLabel()
        favoritesNftEmptyLabel.isHidden = true
    }
    // MARK: - NAVBAR SETUP
    private func navbarSetup() {
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(self.dismissButtonClicked)
        )
        leftButton.tintColor = .ypBlack
        navigationItem.title = "Profile.Favorites.Title"~
        navigationItem.leftBarButtonItem = leftButton
    }
    // MARK: - GESTURE SETTING
    private func setupGestureRecognizers() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    // MARK: - OBJC
    @objc
    func swipeAction(swipe: UISwipeGestureRecognizer) {
        delegate?.updateProfile()
        self.navigationController?.popViewController(animated: true)
    }
    @objc
    func dismissButtonClicked() {
        delegate?.updateProfile()
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - CONSTRAITS
    private func constraitsFavoritesNftCollectionView() {
        NSLayoutConstraint.activate([
            favoritesNftCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            favoritesNftCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoritesNftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesNftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    private func constraitsFavoritesNftEmptyLabel() {
        NSLayoutConstraint.activate([
            favoritesNftEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoritesNftEmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
// MARK: - UICollectionViewDelegate
extension FavoritesNFTViewController: UICollectionViewDelegate {

}
// MARK: - UICollectionViewDataSource
extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presenter.getFavoriteNft()?.count ?? 0 > 0 {
            favoritesNftEmptyLabel.isHidden = true
        } else {
            favoritesNftEmptyLabel.isHidden = false
        }
        return presenter.getFavoriteNft()?.count ?? 0
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesNFTCollectionViewCell.favoritesNftCellIdentifier,
            for: indexPath
        ) as? FavoritesNFTCollectionViewCell
        else {return UICollectionViewCell()}
        guard let nftSetting = presenter.getFavoriteNft()?[indexPath.row] else { return cell}
        cell.configureFavNftCell(
            favNftImageUrl: nftSetting.images.first,
            favNftTitle: nftSetting.name,
            favNftRaiting: nftSetting.rating,
            favNftPrice: nftSetting.price,
            favnftId: nftSetting.id
        )
        cell.delegate = self
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - 9
        let cellWidth = availableWidth / CGFloat(2)
        return CGSize(width: cellWidth, height: 80)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesNFTViewController: FavoritesNFTViewProtocol {
    func displayFavoritesNft(_ nft: [Nft]) {
        favoritesNftCollectionView.reloadData()
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
extension FavoritesNFTViewController: FavoritesNFTCollectionViewCellDelegate {
    func removeLike(nftId: String) {
        presenter.removeFavoriteNft(nftId: nftId)
    }
}
