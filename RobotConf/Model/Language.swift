//
//  Language.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation

struct Language: OptionSet, Hashable {
    let rawValue: Int

    static let french = Language(rawValue: 1 << 0)
    static let english = Language(rawValue: 1 << 1)

    static let all: Language = [.french, .english]
}
