//
//  App.swift
//  Beer
//
//  Created by jc.kim on 2/6/23.
//

import Foundation

struct App: Decodable, Hashable {
    let id: Int
    let tagline: String
    let name: String
    let subheading: String
    let image: String
    let iap: Bool
}
