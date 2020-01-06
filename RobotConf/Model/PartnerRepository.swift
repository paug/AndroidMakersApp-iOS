//
//  TalkRepository.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import Combine

/// Partner list API
class PartnerRepository {
    @Published private var partners = [PartnerCategory]()

    private var cancellables: Set<AnyCancellable> = []

    init(dataProvider: DataProvider) {
        dataProvider.partnerPublisher
            .replaceError(with: [])
            .sink { [unowned self] in
                self.partners = $0
        }
        .store(in: &cancellables)
    }

    func getPartners() -> AnyPublisher<[PartnerCategory], Never> {
        return $partners.eraseToAnyPublisher()
    }
}
