//
//  AgendaCellView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import SwiftUI

struct AgendaCellView: View {
    var talk: AgendaDayListViewModel.Content.Talk

    var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(talk.title)
                    .foregroundColor(.blue)
                    .font(.headline)
                    .padding(.bottom, 4)
                // swiftlint:disable:next line_length
                Text("\(durationFormatter.string(from: talk.duration)!) / \(talk.room) / \(talk.language.flagDescription)")
                    .font(.footnote)
                Text(talk.speakers.map { $0.name }.joined(separator: ", "))
                    .font(.footnote)
                Spacer()
            }
            Spacer()
            Text(talk.state.localizedDescription)
                .font(.footnote)
                .bold()
        }
    }
}

extension AgendaDayListViewModel.Content.Talk.State {
    var localizedDescription: String {
        switch self {
        case .current:  return L10n.Agenda.Detail.State.current
        case .isComing: return L10n.Agenda.Detail.State.isComing
        case .none:     return ""
        }
    }
}

#if DEBUG
struct AgendaCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AgendaCellView(talk: AgendaDayListViewModel.Content.Talk(
                uid: "1",
                title: "The infinite loop", duration: 25 * 60,
                speakers: [Speaker(name: "Toto", photoUrl: "/images/people/florent_champigny.jpg",
                                   company: "", description: "")],
                room: "Room 2.04", language: .french, state: .current))
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
#endif
