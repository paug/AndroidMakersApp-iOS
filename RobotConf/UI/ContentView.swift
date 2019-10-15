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
        NavigationView {
            TabView(selection: $selection) {
                AgendaDayListView(viewModel: AgendaDayListViewModel())
                    .tabItem {
                        VStack {
                            Image("first")
                            Text("Agenda")
                        }
                }.tag(0)
                Text("TODO Lieu")
                    .tabItem {
                        VStack {
                            Image("second")
                            Text("Lieu")
                        }
                }.tag(1)
                Text("TODO A propos")
                    .tabItem {
                        VStack {
                            Image("second")
                            Text("A propos")
                        }
                }.tag(2)
            }.navigationBarTitle(Text("Android Makers 20²"), displayMode: .large)
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
