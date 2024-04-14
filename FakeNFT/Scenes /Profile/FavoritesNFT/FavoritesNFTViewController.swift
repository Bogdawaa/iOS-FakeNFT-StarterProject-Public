//
//  favoritesNFTViewController.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 02.04.2024.
//

import Foundation
import UIKit

final class FavoritesNFTViewController: UIViewController {
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
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navbarSetup()
        setupGestureRecognizers()
        constraitsFavoritesNftCollectionView()
       // favoritesNftCollectionView.isHidden = true
        constraitsFavoritesNftEmptyLabel()
        favoritesNftEmptyLabel.isHidden = true
    }
    // MARK: - NAVBAR SETUP
    private func navbarSetup() {
        if let navbar = navigationController?.navigationBar {
            let leftButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(self.dismissButtonClicked)
            )
            leftButton.tintColor = .ypBlack
            navigationItem.leftBarButtonItem = leftButton
            let navbarLabel = UILabel()
            navbarLabel.text = "Profile.Favorites.Title"~
            navbarLabel.font = .bodyBold
            navbar.topItem?.titleView = navbarLabel
        }
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
        self.dismiss(animated: true)
    }
    @objc
    func dismissButtonClicked() {
        self.dismiss(animated: true)
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
       return 25
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
