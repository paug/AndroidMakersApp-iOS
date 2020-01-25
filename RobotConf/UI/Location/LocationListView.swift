//
//  LocationListView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 29/12/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import SwiftUI

struct LocationListView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: LocationVenueView(kind: .conference)) {
                    Text(L10n.Locations.conference)
                }
                NavigationLink(destination: LocationVenueView(kind: .party)) {
                    Text(L10n.Locations.party)
                }
                NavigationLink(destination: LocationPlanView()) {
                    Text(L10n.Locations.plan)
                }
            }.navigationBarTitle(Text(L10n.Locations.navTitle), displayMode: .large)
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
