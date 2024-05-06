//
//  EditProfileService.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 17.04.2024.
//
import Foundation

struct EditProfileResult: Decodable {
    let profile: Profile?
}

typealias EditProfileCompletion = (Result<EditProfile, Error>) -> Void

protocol EditProfileService {
    func updateProfile(editProfileModel: EditProfile, completion: @escaping EditProfileCompletion)
}

// MARK: - EditProfileService
final class EditProfileServiceImpl: EditProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func updateProfile(editProfileModel: EditProfile, completion: @escaping EditProfileCompletion) {
        var request = ProfileByRequest(httpMethod: .put, id: "1")
        request.httpBody = makeBody(editProfileModel)
        networkClient.send(request: request, type: EditProfile.self) {result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func makeBody(_ editProfileModel: EditProfile) -> String {
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "name", value: editProfileModel.name))
        queryItems.append(URLQueryItem(name: "description", value: editProfileModel.description))
        queryItems.append(URLQueryItem(name: "website", value: editProfileModel.website))
        queryItems.append(URLQueryItem(name: "avatar", value: editProfileModel.avatar))
        components.queryItems = queryItems
        return components.query ?? ""
    }
}
