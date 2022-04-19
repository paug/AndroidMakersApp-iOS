//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import SwiftUI
import URLImage

struct AboutView: View {
    @ObservedObject private var viewModel = AboutViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all)
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
                                    WebButton(url: URL(string: "https://androidmakers.fr/faq")!) {
                                        Text(L10n.About.faq)
                                    }
                                    WebButton(url: URL(string: "https://androidmakers.fr/coc")!) {
                                        Text(L10n.About.coc)
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
                                                URLImage(partner.logoUrl) { image in
                                                    image
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
                .background(Color(.secondarySystemBackground))
                .navigationBarTitle(Text(L10n.About.navTitle), displayMode: .inline)
            }
        }
        // must ensure that the stack navigation is used otherwise it is considered as a master view
        // and nothing is shown in the detail
        .navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
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

#if DEBUG
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        injectMockModel()
        return AboutView()
    }
}
#endif
