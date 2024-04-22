//
//  UsersCollectionViewController.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit
import Kingfisher

final class UsersCollectionViewController: StatLoggedUIViewController {

    var presenter: UsersCollectionPresenterProtocol
    internal lazy var activityIndicator = UIActivityIndicatorView()

    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 108, height: 192)
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.register(UsersCollectionCell.self)
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()

    // MARK: - init
    init(presenter: UsersCollectionPresenterProtocol, statlog: StatLog) {
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

        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self

        setupUI()
        applyConstraints()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .ypWhite
        title = "UserCard.collectionNFTTableTitle"~
    }

    private func applyConstraints() {
        nftCollectionView.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: nftCollectionView)

        view.addSubview(nftCollectionView)
        let nftCollectionViewConstraints = [
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(nftCollectionViewConstraints)
    }
}

extension UsersCollectionViewController: UsersCollectionViewProtocol {
    func loadingDataStarted() {
        showLoading()
    }

    func loadingDataFinished() {
        hideLoading()
    }

    func reloadCollectionView() {
        nftCollectionView.reloadData()
    }
}

extension UsersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.nftsCount()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UsersCollectionCell.defaultReuseIdentifier,
            for: indexPath
        ) as? UsersCollectionCell else {
            return UICollectionViewCell()
        }
        let nft = presenter.nftForIndex(indexPath: indexPath)
        let url = nft.images.first
        cell.delegate = self
        cell.nftImageView.kf.setImage(with: url)
        cell.setupData(with: nft)
        return cell
    }
}

extension UsersCollectionViewController: UsersCollectionCellDelegate {
    func favouriteButtonTapped(_ cell: UsersCollectionCell) {
        cell.changeFavouriteButton()
    }

    func addToCartButtonTapped(_ cell: UsersCollectionCell) {
        guard let indexPath = nftCollectionView.indexPath(for: cell) else { return }
        let nft = presenter.nftForIndex(indexPath: indexPath)
        presenter.addToCart(nft: nft)
        cell.changeCartButton()
    }
}
