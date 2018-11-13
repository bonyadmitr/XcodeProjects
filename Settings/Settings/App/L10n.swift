// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// About
  static var about: String {
    return L10n.tr("Localizable", "about")
  }
  /// appearance
  static var appearance: String {
    return L10n.tr("Localizable", "appearance")
  }
  /// checked
  static var checked: String {
    return L10n.tr("Localizable", "checked")
  }
  /// Developer Apps
  static var developerApps: String {
    return L10n.tr("Localizable", "developer_apps")
  }
  /// Do you like the app?
  static var doYouLikeApp: String {
    return L10n.tr("Localizable", "do_you_like_app")
  }
  /// Don't show it again
  static var dontShowItAgain: String {
    return L10n.tr("Localizable", "dont_show_it_again")
  }
  /// Full screen
  static var fullScreen: String {
    return L10n.tr("Localizable", "full_screen")
  }
  /// Installed
  static var installed: String {
    return L10n.tr("Localizable", "installed")
  }
  /// Language
  static var language: String {
    return L10n.tr("Localizable", "language")
  }
  /// More apps from me
  static var moreAppsFromMe: String {
    return L10n.tr("Localizable", "more_apps_from_me")
  }
  /// More apps from me at App Store
  static var moreAppsFromMeAppStore: String {
    return L10n.tr("Localizable", "more_apps_from_me_app_store")
  }
  /// New apps
  static var newApps: String {
    return L10n.tr("Localizable", "new_apps")
  }
  /// Open in App Store
  static var openInAppStore: String {
    return L10n.tr("Localizable", "open_in_app_store")
  }
  /// Privacy Policy
  static var privacyPolicy: String {
    return L10n.tr("Localizable", "privacy_policy")
  }
  /// Rate now
  static var rateNow: String {
    return L10n.tr("Localizable", "rate_now")
  }
  /// Rate Us
  static var rateUs: String {
    return L10n.tr("Localizable", "rate_us")
  }
  /// Rate us, please, to share it with others!
  static var rateUsShareIt: String {
    return L10n.tr("Localizable", "rate_us_share_it")
  }
  /// Remind me later
  static var remindMeLater: String {
    return L10n.tr("Localizable", "remind_me_later")
  }
  /// Send feedback
  static var sendFeedback: String {
    return L10n.tr("Localizable", "send_feedback")
  }
  /// Settings
  static var settings: String {
    return L10n.tr("Localizable", "settings")
  }
  /// Support
  static var support: String {
    return L10n.tr("Localizable", "support")
  }
  /// Dark
  static var themeNameDark: String {
    return L10n.tr("Localizable", "theme_name_dark")
  }
  /// Dark Negative
  static var themeNameDarkNegative: String {
    return L10n.tr("Localizable", "theme_name_dark_negative")
  }
  /// Default
  static var themeNameDefault: String {
    return L10n.tr("Localizable", "theme_name_default")
  }
  /// Default Black
  static var themeNameDefaultBlack: String {
    return L10n.tr("Localizable", "theme_name_default_black")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    if format == key, let path = Bundle.main.path(forResource: "en", ofType: "lproj"), let bundle = Bundle(path: path) {
        let formatEn = bundle.localizedString(forKey: key, value: key, table: table)
        return String(format: formatEn, locale: Locale.current, arguments: args)
    }
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
