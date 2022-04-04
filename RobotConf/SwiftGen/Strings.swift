// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum About {
    /// Code of conduct
    internal static let coc = L10n.tr("Localizable", "about.coc")
    /// RobotConf Paris is a two day event held on April 20th and 21st, 2020.
    /// 
    /// Join us in tackling the present and future of Robot with the hottest experts of the domain.
    /// There'll be technical sessions, workshops, debates, networking.
    /// RobotConf gathers 4 events in 1.
    /// 
    /// ∙ Conferences : 40min Tech Talks by awesome speakers and 20min Lightning Talks on the future of Robot.
    /// ∙ Workshop : Get trained on new methods, discover and build your app during the workshops.
    /// 
    /// All the talks will be recorded, and uploaded on the Youtube channel.
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
    /// RobotConf 20²
    internal static let navTitle = L10n.tr("Localizable", "agenda.navTitle")
    /// Agenda
    internal static let tabTitle = L10n.tr("Localizable", "agenda.tabTitle")
    internal enum Detail {
      /// Watch this talk on the platform
      internal static let platform = L10n.tr("Localizable", "agenda.detail.platform")
      /// Ask a question to the speaker on Slido
      internal static let question = L10n.tr("Localizable", "agenda.detail.question")
      /// %@ at %@ - %@, %@
      internal static func summary(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any) -> String {
        return L10n.tr("Localizable", "agenda.detail.summary", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4))
      }
      internal enum Feedback {
        /// This talk cannot be reviewed now.
        /// Please come back after attending it.
        internal static let notAvailable = L10n.tr("Localizable", "agenda.detail.feedback.notAvailable")
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
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
