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

final class UserServicesAssembly {

    private let networkClient: NetworkClient
    private let usersStorage: UsersStorage

    var usersService: UsersService {
        UsersServiceImpl(
            networkClient: networkClient,
            storage: usersStorage
        )
    }

    init(
        networkClient: NetworkClient,
        usersStorage: UsersStorage
    ) {
        self.networkClient = networkClient
        self.usersStorage = usersStorage
    }
}
