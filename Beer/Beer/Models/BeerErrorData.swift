//
//  PunkErrorData.swift
//  Beer
//
//  Created by jc.kim on 2/9/23.
//

import Foundation

struct BeerErrorData: Codable {
    let statusCode: Int
    let error: String
    let message: String
}
