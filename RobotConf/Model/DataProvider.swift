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

    private let sessionProvider: SessionProvider
    private let speakersProvider: SpeakersProvider

    private var cancellables: Set<AnyCancellable> = []

    init() {
        let db = Firestore.firestore()
        sessionProvider = SessionProvider(db: db)
        speakersProvider = SpeakersProvider(db: db)

        computeTalks()
    }

    private func computeTalks() {
        sessionProvider.sessionPublisher.combineLatest(speakersProvider.speakersPublisher)
            .sink(receiveCompletion: { error in
            print("Dja EEERRRROR \(error)")
        }) { [unowned self] (sessions, speakers) in
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
                let talk = Talk(
                    id: sessionId, title: session.title, description: session.description,
                    duration: 40 * 60, speakers: sessionSpeakers,
                    startTime: Date(timeIntervalSinceReferenceDate: Double(Int.random(in: 0..<5) * 60 * 60)),
                    room: "Blin", language: .french)
                talks.append(talk)
            }
            self.talksPublisher.send(talks)
        }.store(in: &cancellables)
    }
}
