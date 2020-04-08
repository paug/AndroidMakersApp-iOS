//
//  ContentView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 08/10/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
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

            // This year, because of Covid-19, we won't have a party and no need for plan so only display the
            //"conference" part. This part will hopefully give insights about the streaming platform
            //LocationListView()
            NavigationView { LocationVenueView(kind: .conference) }
                .tabItem {
                    VStack {
                        Image("location")
                        Text(L10n.Locations.tabTitle)
                    }
            }.tag(1)

            AboutView()
                .tabItem {
                    VStack {
                        Image("about")
                        Text(L10n.About.tabTitle)
                    }
            }.tag(2)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
