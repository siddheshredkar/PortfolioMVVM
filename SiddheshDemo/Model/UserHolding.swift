//
//  UserHolding.swift
//  SiddheshDemo
//
//  Created by Siddhesh Redkar on 21/12/24.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let userHoldings: [UserHolding]?

    enum CodingKeys: String, CodingKey {
        case userHoldings = "userHolding" // Map "userHolding" to "userHoldings"
    }
}

// MARK: - UserHolding
struct UserHolding: Codable {
    let symbol: String?
    let quantity: Int?
    let ltp, avgPrice, close: Double?
}
