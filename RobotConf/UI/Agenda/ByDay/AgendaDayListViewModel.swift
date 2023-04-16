//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
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
            let room: String?
            let language: Language?
            let state: State

            var isATalk: Bool { return !speakers.isEmpty }
        }

        struct Section: Hashable {
            let date: Date
            var talks: [Talk]
            let isNewDay: Bool
        }

        var sections: [Section]
    }

    @Published var content: Content = Content(sections: [])
    @Published var favoriteTalks: Set<String> = []

    private var talkRepo: TalkRepository
    private var disposables = Set<AnyCancellable>()
    private var timer: Timer?
    private var isDisplayed = false

    init(talkRepo: TalkRepository = model.talkRepository) {
        self.talkRepo = talkRepo
        talkRepo.getTalks().sink { [weak self] in
            self?.talksChanged(talks: $0)
        }.store(in: &disposables)

        talkRepo.getFavoriteTalks().sink { [unowned self] in
            // only update when view is displayed otherwise it will redisplay the list when the favorite state changes
            if self.isDisplayed {
                self.favoriteTalks = $0
            }
        }.store(in: &disposables)
    }

    func viewAppeared() {
        isDisplayed = true
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.talksChanged(talks: self.talkRepo.talks)
        }
        // recompute talks in case status have changed
        talksChanged(talks: self.talkRepo.talks)
        favoriteTalks = talkRepo.favoriteTalks
    }

    func viewDisappeared() {
        timer?.invalidate()
        timer = nil
        isDisplayed = false
    }

    func toggleFavorite(ofTalk talk: Content.Talk) {
        if favoriteTalks.contains(talk.uid) {
            talkRepo.removeTalkToFavorite(talkId: talk.uid)
        } else {
            talkRepo.addTalkToFavorite(talkId: talk.uid)
        }
    }

    private func talksChanged(talks: [Talk]) {
        let groupedTalks = Dictionary(grouping: talks) { $0.startTime }
        let sortedKeys = groupedTalks.keys.sorted()
        var sections = [Content.Section]()
        var previousDate: Date?
        let calendar = Calendar.current
        sortedKeys.forEach { date in
            // can force unwrap since we're iterating amongst the keys
            let talks = groupedTalks[date]!
                .sorted { $0.room.index < $1.room.index }
                .map { Content.Talk(from: $0) }

            sections.append(Content.Section(
                date: date,
                talks: talks,
                isNewDay: !calendar.isDate(date, inSameDayAs: previousDate ?? Date.distantPast)))

            previousDate = date
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
                  room: talk.isATalk ? talk.room.name : nil,
                  language: talk.isATalk ? talk.language : nil,
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
