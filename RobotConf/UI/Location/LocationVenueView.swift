//
//  Copyright © 2020 Paris Android User Group. All rights reserved.
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
        viewModel.content.map { content in
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

                    // Set the width to 320 because it is the smallest width of the iPhones. This is a really dirty hack
                    // but using a geometry destroys the UI.
                    AttributedLabel(attributedText: content.description.asHtmlAttributedString, width: 320)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)

                    Button(L10n.Locations.directions) {
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
            .navigationBarTitle(Text(content.name), displayMode: .inline)
        }
    }
}

#if DEBUG
struct LocationVenueView_Previews: PreviewProvider {
    static var previews: some View {
        injectMockModel()
        return LocationVenueView(kind: .conference)
    }
}
#endif
