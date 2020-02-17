//
//  Vote.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 10/02/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation
import UIKit

struct TalkFeedback {
    struct Proposition: Hashable {
        let uid: String
        let text: String
    }
    struct PropositionInfo {
        let numberOfVotes: Int
        let userHasVoted: Bool
    }
    let talkId: String
    let colors: [UIColor]
    let propositions: [Proposition]
    let propositionInfos: [Proposition: PropositionInfo]
}
