//
//  TalkRepository.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import Combine

/// Talk API
class TalkRepository {
    @Published private(set) var talks = [Talk]()
    @Published private(set) var favoriteTalks = Set<String>()

    private let userPrefs = UserPrefs()
    private var cancellables: Set<AnyCancellable> = []

    init(dataProvider: DataProvider) {
        dataProvider.talksPublisher
            .replaceError(with: [])
            .sink { [unowned self] in
                self.talks = $0
        }
        .store(in: &cancellables)

        favoriteTalks = Set(userPrefs.getFavoriteTalks())
    }

    func addTalkToFavorite(talkId: String) {
        favoriteTalks.insert(talkId)
        updateUserPrefs()
    }

    func removeTalkToFavorite(talkId: String) {
        favoriteTalks.remove(talkId)
        updateUserPrefs()
    }

    func getTalks() -> AnyPublisher<[Talk], Never> {
        return $talks.eraseToAnyPublisher()
    }

    func getFavoriteTalks() -> AnyPublisher<Set<String>, Never> {
        return $favoriteTalks.eraseToAnyPublisher()
    }

    private func updateUserPrefs() {
        userPrefs.setFavoriteTalks(Array(favoriteTalks))
    }
}
