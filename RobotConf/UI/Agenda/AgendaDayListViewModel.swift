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
            let id: String
            let title: String
            let duration: TimeInterval
            let speakers: [Speaker]
            let room: String
            let language: Language
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
    
    init(talkRepo: TalkRepository = talkRepository) {
        self.talkRepo = talkRepo
        talkRepo.getTalks().sink { [weak self] in
            self?.talksChanged(talks: $0)
        }.store(in: &disposables)
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
        self.init(id: talk.id,
                  title: talk.title,
                  duration: talk.duration,
                  speakers: talk.speakers,
                  room: talk.room,
                  language: talk.language)
    }
}
