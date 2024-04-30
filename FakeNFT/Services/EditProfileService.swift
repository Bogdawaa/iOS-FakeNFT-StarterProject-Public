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
        let profileData = "name=\(editProfileModel.name)&description=\(editProfileModel.description)&website=\(editProfileModel.website)&avatar=\(editProfileModel.avatar)"
        request.httpBody = profileData
        networkClient.send(request: request, type: EditProfile.self) {result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
