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
                            Text(L10n.About.explanation)
                                .foregroundColor(Color.black)
                            HStack(spacing: 24) {
                                Button(L10n.About.faq) {
                                    self.viewModel.openFaqPage()
                                }
                                Button(L10n.About.coc) {
                                    self.viewModel.openCodeOfConductPage()
                                }
                            }.padding(8)
                        }.padding(8)
                    }
                    Card {
                        VStack {
                            Text(L10n.About.social)
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
                                        .foregroundColor(Color(Asset.Colors.twitter.color))
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
                            Text(L10n.About.sponsors)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.blue)
                            ForEach(self.viewModel.partnerCategories, id: \.self) { category in
                                VStack {
                                    Text(category.categoryName)
                                        .foregroundColor(Color.black)
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
                                        }
                                        .frame(maxHeight: 50)
                                    }
                                }
                            }
                            Spacer(minLength: 8)
                        }.padding(8)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(0)
            .background(Color(Asset.Colors.backgroundSecondary.color))
            .navigationBarTitle(Text(L10n.About.navTitle), displayMode: .inline)
        }
    }
}

struct Card<Content: View>: View {
    let content: () -> Content

    var body: some View {
        VStack {
            content()
        }.frame(minWidth: 0, maxWidth: .infinity)
            .background(Color(Asset.Colors.cardBackground.color))
            .cornerRadius(8)
            .padding(8)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
