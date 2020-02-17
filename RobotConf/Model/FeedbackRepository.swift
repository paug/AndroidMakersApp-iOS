//
//  FeedbackRepository.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 03/02/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation
import Combine

class FeedbackRepository {
    @Published private(set) var feedbacks = [String: TalkFeedback]()

    private var cancellables: Set<AnyCancellable> = []
    private let dataProvider: DataProvider

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        dataProvider.votesPublisher
            .replaceError(with: [:])
            .sink { [unowned self] in
                self.feedbacks = $0
        }
        .store(in: &cancellables)
    }

    func vote(_ proposition: TalkFeedback.Proposition, for talkId: String) {
        dataProvider.vote(proposition, for: talkId)
    }

    func removeVote(_ proposition: TalkFeedback.Proposition, for talkId: String) {
        dataProvider.removeVote(proposition, for: talkId)
    }

    func getFeedbacks() -> AnyPublisher<[String: TalkFeedback], Never> {
        return $feedbacks.eraseToAnyPublisher()
    }
}
