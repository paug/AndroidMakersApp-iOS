//
//  AgendaFeedbackChoiceViewModel.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 12/02/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation
import UIKit

class AgendaFeedbackChoiceViewModel: ObservableObject, Identifiable {

    struct Content {
        struct RatioPosition {
            let horizontalRatio: Double
            let verticalRatio: Double
        }
        let title: String
        let votes: [RatioPosition]
        fileprivate(set) var userHasVoted: Bool
        let availableColors: [UIColor]
    }

    @Published var content: Content

    let feedbackRepo: FeedbackRepository
    private let talkVote: TalkVote
    private let index: Int

    private let proposition: TalkVote.Proposition

    init(vote: TalkVote, index: Int, feedbackRepo: FeedbackRepository = model.feedbackRepository) {
        self.talkVote = vote
        self.index = index
        self.feedbackRepo = feedbackRepo
        self.proposition = vote.propositions[index]
        let propositionInfo = vote.propositionInfos[proposition]
        let numberOfVotes: Int
        if let propositionInfo = propositionInfo {
            numberOfVotes = propositionInfo.numberOfVotes - (propositionInfo.userHasVoted ? 1 : 0)
        } else {
            numberOfVotes = 0
        }
        let votes = (0..<numberOfVotes).map { _ in
            Content.RatioPosition(horizontalRatio: Double.random(in: -1.0..<1.0),
                                  verticalRatio: Double.random(in: -1.0..<1.0))
        }
        content = Content(title: proposition.text, votes: votes,
                          userHasVoted: propositionInfo?.userHasVoted ?? false, availableColors: vote.colors)
    }

    func voteOrUnvote() {
        if content.userHasVoted {
            print("Unvote called")
            feedbackRepo.removeVote(proposition, for: talkVote.talkId)
        } else {
            print("Vote called")
            feedbackRepo.vote(proposition, for: talkVote.talkId)
        }
        print("Content.userVote = \(content.userHasVoted)")
        content.userHasVoted.toggle()
        print("Content.userVote = \(content.userHasVoted)")
    }

    private func computeVotes(from propositionInfo: TalkVote.PropositionInfo?) -> [Content.RatioPosition] {
        guard let propositionInfo = propositionInfo else { return [] }
        let numberOfVotes = propositionInfo.numberOfVotes - (propositionInfo.userHasVoted ? 1 : 0)
        return (0..<numberOfVotes).map { _ in
            Content.RatioPosition(horizontalRatio: Double.random(in: -1.0..<1.0),
                                  verticalRatio: Double.random(in: -1.0..<1.0))

        }
    }
}
