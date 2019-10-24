//
//  AgendaDetailView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 13/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import SwiftUI
import URLImage

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

    init(talkId: String) {
        viewModel = AgendaDetailViewModel(talkId: talkId)
    }

    var body: some View {
        containedView()
            .navigationBarTitle(Text(viewModel.content?.title ?? ""), displayMode: .inline)
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
                        .padding(.top, 16)
                    Text("\(fullDateFormatter.string(from: content.startDate)) à " +
                        "\(timeFormatter.string(from: content.startDate)) - " +
                        "\(timeFormatter.string(from: content.endDate)), " +
                        "\(content.room)")
                        .padding(.bottom, 8)
                    Text(content.description)
                    HStack {
                        ForEach(content.tags, id: \.self) { tag in
                            TagView(text: tag)
                        }
                    }
                    Divider().padding(.top, 8)
                    Spacer()
                    ForEach(content.speakers, id: \.self) { speaker in
                        SpeakerView(speaker: speaker)
                    }
                }.padding(.horizontal, 8)
        })
    }
}

struct TagView: View {
    var text: String

    var body: some View {
        Text(text)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.gray)
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 35))
    }
}

struct SpeakerView: View {
    var speaker: Speaker
    let url = URL(string: "https://androidmakers.fr")!

    var body: some View {
        HStack(alignment: .top) {
            URLImage(URL(string: "https://androidmakers.fr\(speaker.photoUrl ?? "")")!) { proxy in
                proxy.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }.frame(width: 64, height: 64)
            VStack(alignment: .leading) {
                Text(speaker.name)
                    .padding(.vertical, 24)
                Text(speaker.description)
            }
        }
        .padding(.vertical, 8)
    }
}

struct AgendaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaDetailView(talkId: "1")
    }
}