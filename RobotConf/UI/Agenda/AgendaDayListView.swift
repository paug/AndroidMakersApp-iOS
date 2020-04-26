//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import SwiftUI
import Combine

struct AgendaDayListView: View {
    @ObservedObject private var viewModel = AgendaDayListViewModel()
    @State private var favOnly = false

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
                    // swiftlint:disable:next line_length
                    Section(header: Text("\(self.sectionDateFormatter.string(from: section.date)), \(self.sectionTimeFormatter.string(from: section.date))")) {
                        ForEach(self.favOnly ?
                            section.talks.filter({ self.viewModel.favoriteTalks.contains($0.uid) }) : section.talks,
                                id: \.self) { talk in
                                    NavigationLink(destination: AgendaDetailView(talkId: talk.uid)) {
                                        AgendaCellView(talk: talk, viewModel: self.viewModel)
                                    }
                                    .listRowBackground(talk.state != .none ?
                                        Color(Asset.Colors.currentTalk.color) : Color(UIColor.systemBackground))
                        }
                    }
                }
            }
            .navigationBarTitle(Text(L10n.Agenda.navTitle), displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: { self.favOnly.toggle() }) {
                    Image(systemName: favOnly ? "star.fill" : "star").padding()
                }
            )
                .onAppear { self.viewModel.viewAppeared() }
                .onDisappear { self.viewModel.viewDisappeared() }
            // Display the first talk in the detail view to avoid having a white screen
            // (this will be only used when the master and detail are visible together i.e. on ipads)
            if viewModel.content.sections.first?.talks.first?.uid != nil {
                AgendaDetailView(talkId: viewModel.content.sections.first!.talks.first!.uid)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
            // Weird hack to have the master-detail in two columns working
            .padding(1)
    }
}

#if DEBUG
struct AgendaDayListView_Previews: PreviewProvider {
    static var previews: some View {
        injectMockModel()
        return AgendaDayListView()
    }
}
#endif
