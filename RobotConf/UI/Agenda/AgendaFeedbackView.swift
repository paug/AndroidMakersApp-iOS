//
//  AgendaFeedbackView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 03/02/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import SwiftUI

struct AgendaFeedbackView: View {
    @ObservedObject private var viewModel: AgendaFeedbackViewModel

    init(talkId: String) {
        viewModel = AgendaFeedbackViewModel(talkId: talkId)
    }

    var body: some View {
        containedView()
            .navigationBarTitle(Text(viewModel.content?.title ?? ""), displayMode: .inline)
    }

    func containedView() -> AnyView {
        guard let content = viewModel.content else {
            return AnyView(Text("Error..."))
        }

        switch content.availability {
        case .notAvailable:
            return AnyView(Text("This talk cannot be reviewed now. Please try again after attending the talk"))
        case .available(let feedback):
            return AnyView(
                VStack {
                    ForEach(0..<rowsCount(feedback: feedback)) { index in
                        HStack {
                            AgendaFeedbackChoicePairView(vote: feedback, index: index*2)
                        }
                    }
                    Text("Powered by Openfeedback")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.callout)
                        .foregroundColor(Color(UIColor.placeholderText))
                }
            )
        }
    }

    private func rowsCount(feedback: TalkVote) -> Int {
        return Int(ceil(Double(feedback.propositions.count) / 2))
    }
}

struct AgendaFeedbackChoicePairView: View {

    let vote: TalkVote
    let index: Int
    var isAlone: Bool {
        return vote.propositions.count <= index+1
    }

    var body: some View {
        HStack {
            AgendaFeedbackChoiceView(vote: vote, index: index, isAlone: isAlone)
            if !isAlone {
                AgendaFeedbackChoiceView(vote: vote, index: index+1, isAlone: false)
            } else {
                Spacer()
            }
        }
    }
}

struct AgendaFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaFeedbackView(talkId: "XEB-2115")
    }
}
