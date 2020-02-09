// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum About {
    /// Code of conduct
    internal static let coc = L10n.tr("Localizable", "about.coc")
    /// Android Makers Paris is a two day event held on April 23rd and 24th, 2019 at Le Beffroi de Montrouge, in Paris, France.\n\nJoin us in tackling the present and future of Android with the hottest experts of the domain.\nThere'll be technical sessions, workshops, debates, networking, plus a chance to demo your project in the Makers Area.\nAndroid Makers gathers 4 events in 1.\n\n∙ Conferences : 40min Tech Talks by awesome speakers and 20min Lightning Talks on the future of Android.\n∙ Workshop : Get trained on new methods, discover and build your app during the workshops.\n∙ Makers Area : Walk around, play and discover the latest innovation in hardware and software developed by the makers.\n∙ Party! : Let’s meet, talk, drink and party!\n\nAll the Talks will be recorded, and uploaded on the Youtube channel.
    internal static let explanation = L10n.tr("Localizable", "about.explanation")
    /// FAQ
    internal static let faq = L10n.tr("Localizable", "about.faq")
    /// About AM 20²
    internal static let navTitle = L10n.tr("Localizable", "about.navTitle")
    /// Social
    internal static let social = L10n.tr("Localizable", "about.social")
    /// Sponsors
    internal static let sponsors = L10n.tr("Localizable", "about.sponsors")
    /// About
    internal static let tabTitle = L10n.tr("Localizable", "about.tabTitle")
  }

  internal enum Agenda {
    /// Android Makers 20²
    internal static let navTitle = L10n.tr("Localizable", "agenda.navTitle")
    /// Agenda
    internal static let tabTitle = L10n.tr("Localizable", "agenda.tabTitle")
    internal enum Detail {
      /// %@ at %@ - %@, %@
      internal static func summary(_ p1: String, _ p2: String, _ p3: String, _ p4: String) -> String {
        return L10n.tr("Localizable", "agenda.detail.summary", p1, p2, p3, p4)
      }
      internal enum State {
        /// Current
        internal static let current = L10n.tr("Localizable", "agenda.detail.state.current")
        /// Coming
        internal static let isComing = L10n.tr("Localizable", "agenda.detail.state.isComing")
      }
    }
  }

  internal enum Common {
    /// Loading...
    internal static let loading = L10n.tr("Localizable", "common.loading")
  }

  internal enum Locations {
    /// Conference
    internal static let conference = L10n.tr("Localizable", "locations.conference")
    /// Directions
    internal static let directions = L10n.tr("Localizable", "locations.directions")
    /// Locations
    internal static let navTitle = L10n.tr("Localizable", "locations.navTitle")
    /// After party
    internal static let party = L10n.tr("Localizable", "locations.party")
    /// Plan
    internal static let plan = L10n.tr("Localizable", "locations.plan")
    /// Locations
    internal static let tabTitle = L10n.tr("Localizable", "locations.tabTitle")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
