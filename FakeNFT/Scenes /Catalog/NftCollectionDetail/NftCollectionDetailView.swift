import UIKit

protocol NftCollectionDetailViewDelegate: AnyObject {
    var numberOfRows: Int { get }

    func rowData(at indexPath: IndexPath) -> Nft?
    func didSelectRow(at indexPath: IndexPath)
    func itemWillDisplay(at indexPath: IndexPath)
}

final class NftCollectionDetailView: UIView {
    weak var delegate: NftCollectionDetailViewDelegate?

    private var nftCollection: NftCollection?

    internal lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsMultipleSelection = false
        view.backgroundColor = .ypWhite
        view.contentInsetAdjustmentBehavior = .never

        view.register(
            NftCollectionDetailHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NftCollectionDetailHeaderCell.reuseIdentifier
        )
        view.register(
            NftCollectionDetailNftCell.self,
            forCellWithReuseIdentifier: NftCollectionDetailNftCell.reuseIdentifier
        )
        view.register(
            SceletonCell.self,
            forCellWithReuseIdentifier: SceletonCell.reuseIdentifier
        )

        view.dataSource = self
        view.delegate = self

        return view
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .ypWhite

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData(nftCollection: NftCollection) {
        self.nftCollection = nftCollection
        collectionView.reloadData()
    }

    func reloadItem(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(172)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 3)
        group.interItemSpacing = .flexible(8)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 28

        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(0)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

extension NftCollectionDetailView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate?.numberOfRows ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let delegate else { return UICollectionViewCell() }

        var cell: UICollectionViewCell?

        if let data = delegate.rowData(at: indexPath) {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NftCollectionDetailNftCell.reuseIdentifier,
                for: indexPath
            ) as? NftCollectionDetailNftCell {
                cell.initData(nft: data)
                return cell
            }
        } else {
            cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SceletonCell.reuseIdentifier,
                for: indexPath
            )
        }
        return cell ?? UICollectionViewCell()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let nftCollection else { return UICollectionReusableView() }

        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NftCollectionDetailHeaderCell.reuseIdentifier,
            for: indexPath
        ) as? NftCollectionDetailHeaderCell

        guard let view else { return UICollectionReusableView() }

        view.initData(nftCollection: nftCollection)
        return view
    }
}

extension NftCollectionDetailView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        delegate?.itemWillDisplay(at: indexPath)
    }
}
