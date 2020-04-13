//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation
import Combine

class AgendaDetailViewModel: ObservableObject, Identifiable {
    struct Content {
        let talkId: String
        let title: String
        let startDate: Date
        let endDate: Date
        let description: String
        let tags: [String]
        let speakers: [Speaker]
        let room: String
        let language: Language
        let questionUrl: URL?
        let platformUrl: URL?

        var isATalk: Bool { return !speakers.isEmpty }
    }

    @Published var content: Content?

    private var talkRepo: TalkRepository
    private var disposables = Set<AnyCancellable>()

    init(talkId: String, talkRepo: TalkRepository = model.talkRepository) {
        self.talkRepo = talkRepo
        talkRepo.getTalks().sink { [weak self] talks in
            guard let talk = talks.first(where: { $0.uid == talkId }) else {
                // TODO: let the view know that this talks is unknown. To do that, maybe change the type of content
                // to be a type that can give an error
                return
            }

            self?.content = Content(from: talk)
        }.store(in: &disposables)
    }
}

private extension AgendaDetailViewModel.Content {
    init(from talk: Talk) {
        self.init(talkId: talk.uid,
                  title: talk.title,
                  startDate: talk.startTime,
                  endDate: talk.startTime.addingTimeInterval(talk.duration),
                  description: talk.description,
                  tags: talk.tags,
                  speakers: talk.speakers,
                  room: talk.room,
                  language: talk.language,
                  questionUrl: talk.questionUrl,
                  platformUrl: talk.platformUrl)
    }
}
