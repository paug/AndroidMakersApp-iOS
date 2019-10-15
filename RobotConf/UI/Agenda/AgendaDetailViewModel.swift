//
//  AgendaDayListViewModel.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import Combine

class AgendaDetailViewModel: ObservableObject, Identifiable {
    struct Content {
        let title: String
        let startDate: Date
        let endDate: Date
        let description: String
        let speakers: [Speaker]
        let room: String
        let language: Language
    }
    
    @Published var content: Content?
    
    private var talkRepo: TalkRepository
    private var disposables = Set<AnyCancellable>()
    
    init(talkId: Int, talkRepo: TalkRepository = talkRepository) {
        self.talkRepo = talkRepo
        talkRepo.getTalks().sink { [weak self] talks in
            guard let talk = talks.first(where: { $0.id == talkId }) else {
                // TODO: let the view know that this talks is unknown. To do that, maybe change the type of content
                // to be a type that can give an error
                return
            }

            self?.content = Content(from: talk)
        }.store(in: &disposables)
    }
}

extension AgendaDetailViewModel.Content {
    init(from talk: Talk) {
        self.init(title: talk.title,
                  startDate: talk.startTime,
                  endDate: talk.startTime.addingTimeInterval(talk.duration),
                  description: talk.description,
                  speakers: talk.speakers,
                  room: talk.room,
                  language: talk.language)
    }
}
