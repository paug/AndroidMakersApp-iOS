//
//  DataProvider.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 16/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine

class DataProvider {
    let db = Firestore.firestore()

    var talksPublisher = PassthroughSubject<[Talk], Error>()

    private let sessionsProvider: SessionsProvider
    private let speakersProvider: SpeakersProvider
    private let slotsProvider: SlotsProvider

    private var cancellables: Set<AnyCancellable> = []

    init() {
        let db = Firestore.firestore()
        sessionsProvider = SessionsProvider(db: db)
        speakersProvider = SpeakersProvider(db: db)
        slotsProvider = SlotsProvider(db: db)

        computeTalks()
    }

    private func computeTalks() {
        sessionsProvider.sessionsPublisher
            .combineLatest(speakersProvider.speakersPublisher, slotsProvider.slotsPublisher)
            .sink(receiveCompletion: { error in
            print("Dja EEERRRROR \(error)")
        }) { [unowned self] (sessions, speakers, slots) in
            var talks = [Talk]()
            for (sessionId, session) in sessions {
                let sessionSpeakers = session.speakers?.compactMap { speakerId -> Speaker? in
                    if let speaker = speakers[speakerId] {
                        return Speaker(name: speaker.name ?? "", photoUrl: speaker.photo,
                                       company: speaker.company ?? "", description: speaker.bio ?? "")
                    }
                    // else raise an error

                    return nil
                } ?? []
                guard let slot = slots.first(where: { $0.sessionId == sessionId }) else {
                    // if no slot, no need to get the session
                    continue
                }
                let duration = slot.endDate.timeIntervalSince(slot.startDate)
                let talk = Talk(
                    id: sessionId, title: session.title, description: session.description,
                    duration: duration, speakers: sessionSpeakers,
                    startTime: slot.startDate,
                    room: slot.roomId.capitalized, language: Language(from: session.language))
                talks.append(talk)
            }
            self.talksPublisher.send(talks)
        }.store(in: &cancellables)
    }
}

extension Language {
    init(from str: String?) {
        guard let str = str else {
            self = .all
            return
        }
        var language: Language = []
        if str.localizedCaseInsensitiveContains("english") {
            language.formUnion(.english)
        }
        if str.localizedCaseInsensitiveContains("french") {
            language.formUnion(.french)
        }
        self = language
    }
}
