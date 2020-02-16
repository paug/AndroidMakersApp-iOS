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

            fileprivate static func random() -> RatioPosition {
                return RatioPosition(horizontalRatio: Double.random(in: -1.0..<1.0),
                                     verticalRatio: Double.random(in: -1.0..<1.0))
            }
        }
        let title: String
        fileprivate let votes: [RatioPosition]
        fileprivate(set) var userVote: Content.RatioPosition?
        let availableColors: [UIColor]

        var userHasVoted: Bool { userVote != nil }

        var votePositions: [RatioPosition] {
            if let userVote = userVote {
                return votes + [userVote]
            }
            return votes
        }
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
        let userVote: Content.RatioPosition?
        if let propositionInfo = propositionInfo {
            numberOfVotes = propositionInfo.numberOfVotes - (propositionInfo.userHasVoted ? 1 : 0)
            userVote = propositionInfo.userHasVoted ? Content.RatioPosition.random() : nil
        } else {
            numberOfVotes = 0
            userVote = nil
        }
        let votes = (0..<numberOfVotes).map { _ in
            Content.RatioPosition(horizontalRatio: Double.random(in: -1.0..<1.0),
                                  verticalRatio: Double.random(in: -1.0..<1.0))
        }

        content = Content(title: proposition.text, votes: votes,
                          userVote: userVote, availableColors: vote.colors)
    }

    func voteOrUnvote(triggeredFrom ratioPosition: Content.RatioPosition) {
        if content.userHasVoted {
            print("Unvote called")
            feedbackRepo.removeVote(proposition, for: talkVote.talkId)
            content.userVote = nil
        } else {
            print("Vote called")
            feedbackRepo.vote(proposition, for: talkVote.talkId)
            content.userVote = ratioPosition
        }
    }

    private func computeVotes(from propositionInfo: TalkVote.PropositionInfo?) -> [Content.RatioPosition] {
        guard let propositionInfo = propositionInfo else { return [] }
        let numberOfVotes = propositionInfo.numberOfVotes - (propositionInfo.userHasVoted ? 1 : 0)
        return (0..<numberOfVotes).map { _ in
            Content.RatioPosition.random()
        }
    }
}
