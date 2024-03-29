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

final class UserServicesAssembly {

    private let networkClient: NetworkClient
    private let usersStorage: UsersStorage

    init(
        networkClient: NetworkClient,
        usersStorage: UsersStorage
    ) {
        self.networkClient = networkClient
        self.usersStorage = usersStorage
    }

    var usersService: UsersService {
        UsersServiceImpl(
            networkClient: networkClient,
            storage: usersStorage
        )
    }
}
