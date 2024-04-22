import UIKit
import Kingfisher

final class NftCollectionDetailNftCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: NftCollectionDetailNftCell.self)

    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }()

    private lazy var likeImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40)
        ])

        return view
    }()

    private lazy var stars: UIStackView = {
        let views = (0..<5).map { _ in
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 12),
                view.heightAnchor.constraint(equalToConstant: 12)
            ])
            return view
        }

        let view = UIStackView(arrangedSubviews: views)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.axis = .horizontal

        return view
    }()

    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.textColor = .ypBlack

        return view
    }()

    private lazy var price: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.textColor = .ypBlack

        return view
    }()

    private lazy var cartImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40)
        ])

        return view
    }()

    private lazy var vStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [stars, label, price])
        view.translatesAutoresizingMaskIntoConstraints = false

        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 4

        return view
    }()

    private lazy var hStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [vStack, cartImage])
        view.translatesAutoresizingMaskIntoConstraints = false

        view.axis = .horizontal
        view.alignment = .bottom

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .ypWhite

        contentView.addSubview(image)
        contentView.addSubview(likeImage)
        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.topAnchor.constraint(equalTo: self.topAnchor),

            likeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            likeImage.topAnchor.constraint(equalTo: self.topAnchor),

            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: image.bottomAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData(nft: Nft) {
        image.kf.setImage(with: nft.imagesURL[0])
        likeImage.image = .ypLikeWhire
        cartImage.image = .ypCartAdd
        stars.arrangedSubviews.enumerated().forEach { item in
            guard let view = item.element as? UIImageView else { return }
            view.image = Int(nft.price) > item.offset ? .ypStarYellow : .ypStarGray
        }
        label.text = nft.name
        price.text = "\(nft.price) ETH"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image.kf.cancelDownloadTask()
    }
}
