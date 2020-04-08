//
//  Partner.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 05/01/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation

struct Partner: Hashable {
    let name: String
    let logoUrl: URL
    let url: URL?
}

struct PartnerCategory: Hashable {
    let categoryName: String
    let partners: [Partner]
}
