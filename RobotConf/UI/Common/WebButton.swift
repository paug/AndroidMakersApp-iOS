//
//  WebButton.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 12/04/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import SwiftUI
import SafariServices

/// A button that opens a SFSafariWebview in modal
struct WebButton<Label: View>: View {
    // A view that describes the effect of calling `action`.
    private var label: () -> Label

    // initial URL string
       private let url: URL

    // whether or not to show the Safari ViewController
    @State private var showSafari = false

    /// Create the button
    /// - Parameters:
    ///   - url: the url that the button should open when it is clicked
    ///   - label: A view that describes the effect of calling the `action` of the button.
    init(url: URL, @ViewBuilder label: @escaping () -> Label) {
        self.url = url
        self.label = label
    }

    var body: some View {
        Button(action: {
            // tell the app that we want to show the Safari VC
            self.showSafari = true
        }, label: label)
            // summon the Safari sheet
            .sheet(isPresented: $showSafari) { SafariView(url: self.url) }
    }
}

/// A SFSafariViewController view that can be used in SwiftUI
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

struct WebButton_Previews: PreviewProvider {
    static var previews: some View {
        WebButton(url: URL(string: "https://www.google.com")!) { Text("Click me!") }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
