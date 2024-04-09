//
//  Profile.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 26.03.2024.
//

import Foundation

struct User: Decodable {
    let id: String
    let name: String
    let avatar: String
    let rating: String
    let website: String
    let nfts: [String]
    let description: String
}
