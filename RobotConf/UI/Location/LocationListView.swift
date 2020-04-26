//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
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

#if DEBUG
struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        injectMockModel()
        return LocationListView()
    }
}
#endif
