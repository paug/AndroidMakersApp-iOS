//
//  Language+UI.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 12/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation

extension Language {
    var flagDescription: String {
        var flagDescription = ""
        if contains(.english) {
            flagDescription.append("🇬🇧")
        }
        if contains(.french) {
            flagDescription.append("🇫🇷")
        }
        return flagDescription
    }
}
