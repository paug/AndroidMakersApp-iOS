//
//  AgendaDayListViewModel.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import Combine

class AgendaDayListViewModel: ObservableObject, Identifiable {
    struct Content {
        struct Talk: Hashable {
            enum State {
                case current
                case isComing
                case none
            }
            let uid: String
            let title: String
            let duration: TimeInterval
            let speakers: [Speaker]
            let room: String
            let language: Language
            let state: State
        }

        struct Section: Hashable {
            let date: Date
            var talks: [Talk]
        }

        var sections: [Section]
    }

    @Published var content: Content = Content(sections: [])

    private var talkRepo: TalkRepository
    private var disposables = Set<AnyCancellable>()
    private var timer: Timer?

    init(talkRepo: TalkRepository = model.talkRepository) {
        self.talkRepo = talkRepo
        talkRepo.getTalks().sink { [weak self] in
            self?.talksChanged(talks: $0)
        }.store(in: &disposables)
    }

    func viewAppeared() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.talksChanged(talks: self.talkRepo.talks)
        }
    }

    func viewDisappeared() {
        timer?.invalidate()
        timer = nil
    }

    private func talksChanged(talks: [Talk]) {
        let groupedTalks = Dictionary(grouping: talks) { $0.startTime }
        let sortedKeys = groupedTalks.keys.sorted()
        var sections = [Content.Section]()
        sortedKeys.forEach { date in
            // can force unwrap since we're iterating amongst the keys
            let talks = groupedTalks[date]!
                .map { Content.Talk(from: $0) }
                .sorted { $0.room >= $1.room }
            sections.append(Content.Section(date: date, talks: talks))
        }
        content.sections = sections
    }
}

extension AgendaDayListViewModel.Content.Talk {
    init(from talk: Talk) {
        self.init(uid: talk.uid,
                  title: talk.title,
                  duration: talk.duration,
                  speakers: talk.speakers,
                  room: talk.room,
                  language: talk.language,
                  state: State(from: talk))
    }
}

private extension AgendaDayListViewModel.Content.Talk.State {
    // Time before a session to be considered as coming
    private static let timeGapBeforeToCome = -5 * 60.0
    // Time after a session to be still considered as current
    private static let timeGapAfterCurrent = 2.5 * 60.0

    init(from talk: Talk) {
        let currentDate = TimeProvider.instance.currentTime

        let startToNow = currentDate.timeIntervalSince(talk.startTime)
        switch startToNow {
        case Self.timeGapBeforeToCome..<0:
            self = .isComing
        case 0...(talk.duration + Self.timeGapAfterCurrent):
            self = .current
        default:
            self = .none
        }
    }
}
