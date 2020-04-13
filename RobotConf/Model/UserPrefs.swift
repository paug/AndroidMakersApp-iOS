//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
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
