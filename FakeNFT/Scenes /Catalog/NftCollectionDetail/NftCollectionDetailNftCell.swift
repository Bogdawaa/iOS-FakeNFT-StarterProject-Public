import UIKit
import Kingfisher

final class NftCollectionDetailNftCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: NftCollectionDetailNftCell.self)

    weak var delegate: NftCollectionDetailView?

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

    private lazy var likeButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "likeButton"
        view.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
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
        view.spacing = 2

        return view
    }()

    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.font = .bodyBold
        view.textColor = .ypBlack

        return view
    }()

    private lazy var price: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.font = .medium10
        view.textColor = .ypBlack

        return view
    }()

    private lazy var cartButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "cartButton"
        view.addTarget(self, action: #selector(cartButtonClicked), for: .touchUpInside)
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
        view.spacing = 5

        return view
    }()

    private lazy var hStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [vStack, cartButton])
        view.translatesAutoresizingMaskIntoConstraints = false

        view.axis = .horizontal
        view.alignment = .bottom

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .ypWhite

        contentView.addSubview(image)
        contentView.addSubview(likeButton)
        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.topAnchor.constraint(equalTo: self.topAnchor),

            likeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: self.topAnchor),

            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image.kf.cancelDownloadTask()
    }

    func initData(nftModel: NftModel) {
        image.kf.setImage(with: nftModel.nft.imagesURL[0])

        likeButton.setImage(nftModel.isLiked ? .ypLikeRed : .ypLikeWhire, for: .normal)
        cartButton.setImage(nftModel.isInCart ? .ypCartRemove : .ypCartAdd, for: .normal)

        stars.arrangedSubviews.enumerated().forEach { item in
            guard let view = item.element as? UIImageView else { return }
            view.image = Int(nftModel.nft.price) > item.offset ? .ypStarYellow : .ypStarGray
        }
        label.text = nftModel.nft.name
        price.text = "\(nftModel.nft.price) ETH"
    }

    @objc
    func likeButtonClicked() {
        delegate?.likeButtonClicked(self)
    }

    @objc
    func cartButtonClicked() {
        delegate?.cartButtonClicked(self)
    }
}
