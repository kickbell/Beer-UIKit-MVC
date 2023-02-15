//
//  SelfConfiguringCell.swift
//  Beer
//
//  Created by jc.kim on 2/6/23.
//

import Foundation

protocol SelfConfigureCell {
    associatedtype Item
    func configure(with app: Item)
}

