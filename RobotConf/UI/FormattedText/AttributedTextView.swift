//
//  AttributedTextView.swift
//  RobotConf
//
//  Created by Djavan Bertrand on 19/01/2020.
//  Copyright © 2020 Djavan Bertrand. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

/// A SwiftUI label that can accept an attributed string
struct AttributedLabel: UIViewRepresentable {
    var attributedText: NSAttributedString?
    // Width of the label. Needed because there is a bug with layouting a UILabel in swiftUI:
    // https://stackoverflow.com/a/58474880
    var width: CGFloat

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = width
        label.attributedText = attributedText

        return label
    }

    func updateUIView(_ label: UILabel, context: Context) {
        label.attributedText = attributedText
    }
}
