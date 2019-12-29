//
//  LocationPlan.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 29/12/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import SwiftUI

struct LocationPlanView: View {
    var body: some View {
        Image("plan")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle(Text("Plan"), displayMode: .inline)
    }
}

struct LocationPlanView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPlanView()
    }
}
