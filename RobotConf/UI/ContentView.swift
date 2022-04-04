//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            AgendaDayListView()
                .tabItem {
                    VStack {
                        Image("agenda")
                        Text(L10n.Agenda.tabTitle)
                    }
            }.tag(0)

            // This year, because of Covid-19, we won't have a party and no need for plan. The conference part need also
            // to be removed because the screen is not meant to show links.
            // For the moment, we remove the tab.
            // LocationListView()
//                .tabItem {
//                    VStack {
//                        Image("location")
//                        Text(L10n.Locations.tabTitle)
//                    }
//            }.tag(1)

            AboutView()
                .tabItem {
                    VStack {
                        Image("about")
                        Text(L10n.About.tabTitle)
                    }
            }.tag(1)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        injectMockModel()
        return ContentView()
    }
}
#endif
