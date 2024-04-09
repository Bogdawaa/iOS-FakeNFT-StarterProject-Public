//
//  AlertModel.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let buttonTextCancel: String
    let buttonText: String
    let completion: (() -> Void)?
}
