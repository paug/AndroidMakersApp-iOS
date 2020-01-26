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

    private var cancellables: Set<AnyCancellable> = []

    init(dataProvider: DataProvider) {
        dataProvider.talksPublisher
            .replaceError(with: [])
            .sink { [unowned self] in
                self.talks = $0
        }
        .store(in: &cancellables)
    }

    func getTalks() -> AnyPublisher<[Talk], Never> {
        return $talks.eraseToAnyPublisher()
    }
}
