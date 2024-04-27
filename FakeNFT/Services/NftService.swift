import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func updateFavoritesNft(likedNftIds: [String])
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        let request = NFTRequest(httpMethod: .get, id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func updateFavoritesNft(likedNftIds: [String]) {
        var request = ProfileByRequest(httpMethod: .put, id: "1")
        let joined = likedNftIds.isEmpty ? "null" : likedNftIds.joined(separator: ",")
        let profileData = "likes=\(joined)"
        print(profileData)
        request.httpBody = profileData
        networkClient.send(request: request) {result in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
}
