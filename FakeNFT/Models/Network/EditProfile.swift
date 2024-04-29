//
//  EditProfile.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 17.04.2024.
//

import Foundation

struct EditProfile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
}
