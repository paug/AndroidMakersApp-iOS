//
//  AboutView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 31/12/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import SwiftUI
import URLImage

struct AboutView: View {
    @ObservedObject private var viewModel = AboutViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Card {
                        VStack(spacing: 16) {
                           Image("logo_oneline_black_text")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            Text(
"""
Android Makers Paris is a two day event held on April 23rd and 24th, 2019 at Le Beffroi de Montrouge, in Paris, France.

Join us in tackling the present and future of Android with the hottest experts of the domain.
There\'ll be technical sessions, workshops, debates, networking, plus a chance to demo your project in the Makers Area.
Android Makers gathers 4 events in 1.

∙ Conferences : 40min Tech Talks by awesome speakers and 20min Lightning Talks on the future of Android.
∙ Workshop : Get trained on new methods, discover and build your app during the workshops.
∙ Makers Area : Walk around, play and discover the latest innovation in hardware and software developed by the makers.
∙ Party! : Let’s meet, talk, drink and party!

All the Talks will be recorded, and uploaded on the Youtube channel.
"""
                            )
                            HStack(spacing: 24) {
                                Button("FAQ") {
                                    self.viewModel.openFaqPage()
                                }
                                Button("Code of conduct") {
                                    self.viewModel.openCodeOfConductPage()
                                }
                            }.padding(8)
                        }.padding(8)
                    }
                    Card {
                        VStack {
                            Text("Social")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.blue)
                            Button(action: {
                                self.viewModel.openHashtagPage()
                            }) {
                                Text("#AndroidMakers")
                                    .foregroundColor(.blue)
                            }
                            HStack(spacing: 16) {
                                Button(action: {
                                    self.viewModel.openTwitterPage()
                                }) {
                                    Image("twitter")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    // TODO add .foregroundColor(Color.twitter)
                                }
                                Button(action: {
                                    self.viewModel.openYoutubePage()
                                }) {
                                Image("youtube")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.vertical, 16)
                                }

                            }.frame(maxHeight: 50)
                        }.padding(8)
                    }
                    Card {
                        VStack(spacing: 16) {
                            Text("Sponsors")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.blue)
                            ForEach(self.viewModel.partnerCategories, id: \.self) { category in
                                VStack {
                                    Text(category.categoryName)
                                        .bold()
                                        .padding(16)
                                    ForEach(category.partners, id: \.self) { partner in
                                        Button(action: { self.viewModel.openPartnerPage(partner) }) {
                                            URLImage(partner.logoUrl) { proxy in
                                                proxy.image
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                        }.frame(maxHeight: 50)
                                    }
                                }
                            }
                        }.padding(8)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(0)
            .background(Color("colors/tag"))
            .navigationBarTitle(Text("About AM 20²"), displayMode: .inline)
        }
    }
}

struct Card<Content: View>: View {
    let content: () -> Content

    var body: some View {
        VStack {
            content()
        }.frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .padding(8)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
