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
        HStack {
            VStack(alignment: .leading) {
                Text(talk.title)
                    .foregroundColor(.blue)
                    .font(.headline)
                    .padding(.bottom, 4)
                Text("\(durationFormatter.string(from: talk.duration)!) / \(talk.room) / \(talk.language.flagDescription)")
                    .font(.footnote)
                Text(talk.speakers.map { $0.name }.joined(separator: ", "))
                    .font(.footnote)
                Spacer()
            }
            Spacer()
        }
    }
}

#if DEBUG
struct AgendaCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AgendaCellView(talk: AgendaDayListViewModel.Content.Talk(
                id: "1",
                title: "The infinite loop", duration: 25 * 60,
                speakers: [Speaker(name: "Toto", photoUrl: "/images/people/florent_champigny.jpg",
                                   company: "", description: "")],
                room: "Room 2.04", language: .french))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
#endif
