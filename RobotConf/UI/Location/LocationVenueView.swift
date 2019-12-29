//
//  LocationConferenceView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 29/12/2019.
//  Copyright © 2019 Djavan Bertrand. All rights reserved.
//

import SwiftUI
import URLImage
import MapKit

struct LocationVenueView: View {
    @ObservedObject private var viewModel: LocationVenueViewModel

    init(kind: LocationVenueViewModel.VenueKind) {
        viewModel = LocationVenueViewModel(kind: kind)
    }
    
    var body: some View {
        containedView()
            .navigationBarTitle(Text(viewModel.content?.name ?? ""), displayMode: .inline)
    }

    func containedView() -> AnyView {
        guard let content = viewModel.content else {
            return AnyView(Text("Loading..."))
        }

        return AnyView(
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    URLImage(URL(string: content.imageUrl)!) { proxy in
                        proxy.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }.frame(maxHeight: 220)

                    Text(content.address)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)

                    Text(content.description)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)

                    Button("Directions") {
                        let placemark = MKPlacemark(coordinate: content.coordinates)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = content.name
                        mapItem.openInMaps()
                    }.padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .foregroundColor(Color.primary)
                        .background(Color.gray)
                        .cornerRadius(8)

                    Spacer()
                }
            }
        )
    }
}

struct LocationVenueView_Previews: PreviewProvider {
    static var previews: some View {
        LocationVenueView(kind: .conference)
    }
}
