//
//  AgendaDayListView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import SwiftUI
import Combine

struct AgendaDayListView: View {
    @ObservedObject private var viewModel = AgendaDayListViewModel()

    var sectionTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    var sectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.content.sections, id: \.self) { section in
                    Section(header: Text("\(self.sectionDateFormatter.string(from: section.date)), \(self.sectionTimeFormatter.string(from: section.date))")) {
                        ForEach(section.talks, id: \.self) { talk in
                            NavigationLink(destination: AgendaDetailView(talkId: talk.id)) {
                                AgendaCellView(talk: talk)
                            }
                        }
                    }
                }
            }.navigationBarTitle(Text("Android Makers 20²"), displayMode: .large)
        }
    }
}

#if DEBUG
struct AgendaDayListView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaDayListView()
    }
}
#endif
