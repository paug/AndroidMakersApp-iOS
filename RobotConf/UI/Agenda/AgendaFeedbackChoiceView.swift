//
//  AgendaFeedbackChoiceView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 03/02/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import SwiftUI

struct AgendaFeedbackChoiceView: View {

    @ObservedObject private var viewModel: AgendaFeedbackChoiceViewModel

    let isAlone: Bool

    var width: CGFloat {
        UIScreen.main.bounds.width / 2 - 20
    }

    var height: CGFloat {
        150
    }

    init(vote: TalkVote, index: Int, isAlone: Bool) {
        self.isAlone = isAlone
        viewModel = AgendaFeedbackChoiceViewModel(vote: vote, index: index)
    }

    var body: some View {
        ZStack {
            ForEach(0..<viewModel.content.votePositions.count, id: \.self) { index in
                Circle()
                    .foregroundColor(self.color(for: index))
                    .position(self.viewModel.content.votePositions[index].point(
                        forWidth: self.width, height: self.height))
                    .frame(width: 20, height: 20)
            }
            Text(self.viewModel.content.title)
                .lineLimit(3)
            TappableView { location in
                self.viewModel.voteOrUnvote(triggeredFrom: AgendaFeedbackChoiceViewModel.Content.RatioPosition(
                    horizontalRatio: Double(location.x / self.width) * 2 - 1,
                    verticalRatio: Double(location.y / self.height) * 2 - 1))
            }
        }
        .frame(width: width, height: height, alignment: .center)
        .background(viewModel.content.userHasVoted ?
            Color(Asset.Colors.feedbackSelectedColor.color) : Color(Asset.Colors.feedbackColor.color))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: viewModel.content.userHasVoted ? 2 : 0)
                    .foregroundColor(Color.gray)
        )
            .padding(8)
    }

    func color(for index: Int) -> Color {
        let availableColors = viewModel.content.availableColors
        return Color(availableColors[index % availableColors.count].withAlphaComponent(0.3))
    }
}

extension AgendaFeedbackChoiceViewModel.Content.RatioPosition {
    func point(forWidth width: CGFloat, height: CGFloat) -> CGPoint {
        return CGPoint(x: (CGFloat(horizontalRatio) * width / 2) + 10,
                       y: (CGFloat(verticalRatio) * height / 2) + 10)
    }
}

struct TappableView: UIViewRepresentable {
    var tappedCallback: ((CGPoint) -> Void)

    func makeUIView(context: UIViewRepresentableContext<TappableView>) -> UIView {
        let view = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator,
                                             action: #selector(Coordinator.tapped))
        view.addGestureRecognizer(gesture)
        return view
    }

    class Coordinator: NSObject {
        var tappedCallback: ((CGPoint) -> Void)
        init(tappedCallback: @escaping ((CGPoint) -> Void)) {
            self.tappedCallback = tappedCallback
        }
        @objc func tapped(gesture: UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            self.tappedCallback(point)
        }
    }

    func makeCoordinator() -> TappableView.Coordinator {
        return Coordinator(tappedCallback: self.tappedCallback)
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<TappableView>) {
    }

}

struct AgendaFeedbackChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        let proposition = TalkVote.Proposition(uid: "1", text: "A choice")
        return AgendaFeedbackChoiceView(
            vote: TalkVote(
                talkId: "id", colors: [.blue, .red],
                propositions: [proposition],
                propositionInfos: [proposition: TalkVote.PropositionInfo(numberOfVotes: 10, userHasVoted: true)]),
            index: 0, isAlone: false)
    }
}
