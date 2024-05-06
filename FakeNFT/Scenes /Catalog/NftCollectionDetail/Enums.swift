import Foundation

enum NftCollectionDetailViewState {
    case initial
    case loading
    case data(profile: Profile, nftOrder: NftOrder, nfts: [String: Nft])
    case toggleLike(indexPath: IndexPath)
    case likeToggled(indexPath: IndexPath, profile: Profile)
    case toggleCart(indexPath: IndexPath)
    case cartToggled(indexPath: IndexPath, nftOrder: NftOrder)
    case failed(error: NetworkError, action: NftCollectionDetailViewAction)
}

enum NftCollectionDetailViewAction {
    case loading
    case toggleLike(indexPath: IndexPath)
    case toggleCart(indexPath: IndexPath)
}
