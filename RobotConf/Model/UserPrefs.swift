//
//  UserPrefs.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 28/03/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation

class UserPrefs {

    private let favoriteTalksKey = "favoriteTalks"

    func getFavoriteTalks() -> [String] {
        return UserDefaults.standard.stringArray(forKey: favoriteTalksKey) ?? []
    }

    func setFavoriteTalks(_ favoriteTalks: [String]) {
        UserDefaults.standard.set(favoriteTalks, forKey: favoriteTalksKey)
    }
}
