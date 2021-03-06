//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import Foundation
import Combine

class TalkFeedbackViewModel: ObservableObject, Identifiable {
    struct Content {
        enum FeedbackAvailaibility {
            case notAvailable
            case available(TalkFeedback)
        }
        let title: String
        let availability: FeedbackAvailaibility
    }

    @Published var content: Content?

    private var feedbackRepo: FeedbackRepository
    private var disposables = Set<AnyCancellable>()

    init(talkId: String, talkRepo: TalkRepository = model.talkRepository,
         feedbackRepo: FeedbackRepository = model.feedbackRepository) {
        self.feedbackRepo = feedbackRepo
        talkRepo.getTalks().first(where: { !$0.isEmpty })
            .combineLatest(feedbackRepo.getFeedbacks().first(where: { !$0.isEmpty }))
            .sink { [weak self] talks, feedbacks in
                guard let talk = talks.first(where: { $0.uid == talkId }),
                    let feedback = feedbacks[talkId] else {
                    // TODO: let the view know that this talks is unknown. To do that, maybe change the type of content
                    // to be a type that can give an error
                    return
                }

                if talk.startTime >= TimeProvider.instance.currentTime {
                    self?.content = Content(title: talk.title, availability: .notAvailable)
                } else {
                    self?.content = Content(title: talk.title, availability: .available(feedback))
                }
        }.store(in: &disposables)
    }
}
