//
//  AgendaFeedbackView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 03/02/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import SwiftUI

struct TalkFeedbackView: View {
    @ObservedObject private var viewModel: TalkFeedbackViewModel

    init(talkId: String) {
        viewModel = TalkFeedbackViewModel(talkId: talkId)
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
            return AnyView(Text(L10n.Agenda.Detail.Feedback.notAvailable).italic())
        case .available(let feedback):
            return AnyView(
                VStack {
                    ForEach(0..<rowsCount(feedback: feedback)) { index in
                        HStack {
                            AgendaFeedbackChoicePairView(feedback: feedback, index: index*2)
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

    private func rowsCount(feedback: TalkFeedback) -> Int {
        return Int(ceil(Double(feedback.propositions.count) / 2))
    }
}

struct AgendaFeedbackChoicePairView: View {

    let feedback: TalkFeedback
    let index: Int
    var isAlone: Bool {
        return feedback.propositions.count <= index+1
    }

    var body: some View {
        HStack {
            AgendaFeedbackChoiceView(talkFeedback: feedback, index: index, isAlone: isAlone)
            if !isAlone {
                AgendaFeedbackChoiceView(talkFeedback: feedback, index: index+1, isAlone: false)
            } else {
                Spacer()
            }
        }
    }
}

struct TalkFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        TalkFeedbackView(talkId: "XEB-2115")
    }
}
