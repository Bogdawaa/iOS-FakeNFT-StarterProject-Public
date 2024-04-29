final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }
}

final class ProfileServicesAssembly {
    private let networkClient: NetworkClient
    private let profileStorage: ProfileStorage

    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            storage: profileStorage)
    }
    init(
        networkClient: NetworkClient,
        profileStorage: ProfileStorage
    ) {
        self.networkClient = networkClient
        self.profileStorage = profileStorage
    }
}
