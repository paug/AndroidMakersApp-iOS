//
//  AgendaDetailView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 13/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import SwiftUI

struct AgendaDetailView: View {

    @ObservedObject private var viewModel: AgendaDetailViewModel

    var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    var fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE DD MMM YYYY"
        return formatter
    }()

    init(talkId: Int) {
        viewModel = AgendaDetailViewModel(talkId: talkId)
    }

    var body: some View {
        containedView()
            .navigationBarTitle(Text("TOTO"), displayMode: .inline)
    }

    func containedView() -> AnyView {
        guard let content = viewModel.content else {
            return AnyView(Text("Loading..."))
        }

        return AnyView(
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.title)
                        .foregroundColor(.blue)
                        .font(.headline)
                        .padding(.bottom, 8)
                    Text("\(fullDateFormatter.string(from: content.startDate)) à " +
                        "\(timeFormatter.string(from: content.startDate)) - " +
                        "\(timeFormatter.string(from: content.endDate)), " +
                        "\(content.room)")
                        .padding(.bottom, 8)
                    Text(content.description)
                    Spacer()
                }.padding([.leading, .trailing], 8)
        })
    }
}

struct AgendaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaDetailView(talkId: 1)
    }
}
