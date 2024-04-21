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

    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 108, height: 108) // TODO: ??
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.register(UsersCollectionCell.self)
        object.register(
            UsersCollectionCellFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Footer"
        )
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

        navigationController?.title = "UserCard.collectionNFTTableTitle"~
        applyConstraints()
    }

    private func applyConstraints() {
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
    // TODO:
}

extension UsersCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.nftsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UsersCollectionCell.defaultReuseIdentifier,
            for: indexPath) as? UsersCollectionCell else {
            return UICollectionViewCell()
        }
        // TODO: тут в массиве нфт хранятся айди нфт, нужно по ним получать массив объектов нфт.
        let nft = presenter.nftForIndex(indexPath: indexPath)
//        let url = nft.images.first
//        cell.nftImageView.kf.setImage(with: url)
        return cell
    }
}

extension UsersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Footer",
            for: indexPath
        ) as? UsersCollectionCellFooter else { return UICollectionReusableView() }

        let nft = presenter.nftForIndex(indexPath: indexPath)
//        view.setupFooterData(with: nft)
        return view
    }
}

extension UsersCollectionViewController: UICollectionViewDelegate {

}
