//
//  Ingredients.swift
//  Beer
//
//  Created by jc.kim on 2/9/23.
//

import Foundation

struct Ingredients: Codable {
    let malt: [Malt]
    let hops: [Hops]
    let yeast: String
}

struct Malt: Codable {
    let name: String
    let amount: Amount
}

struct Amount: Codable {
    let value: Double
    let unit: String
}

struct Hops: Codable {
    let name: String
    let amount: Amount
    let add: String
    let attribute: String
}
