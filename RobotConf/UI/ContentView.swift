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
                        Text("Agenda")
                    }
            }.tag(0)

            LocationListView()
                .tabItem {
                    VStack {
                        Image("location")
                        Text("Location")
                    }
            }.tag(1)

            AboutView()
                .tabItem {
                    VStack {
                        Image("about")
                        Text("About")
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
