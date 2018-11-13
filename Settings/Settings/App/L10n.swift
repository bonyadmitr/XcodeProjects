// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// About
  static let about = L10n.tr("Localizable", "about")
  /// appearance
  static let appearance = L10n.tr("Localizable", "Appearance")
  /// Developer Apps
  static let developerApps = L10n.tr("Localizable", "developer_apps")
  /// Installed
  static let installed = L10n.tr("Localizable", "installed")
  /// Language
  static let language = L10n.tr("Localizable", "language")
  /// More apps from me
  static let moreAppsFromMe = L10n.tr("Localizable", "more_apps_from_me")
  /// More apps from me at App Store
  static let moreAppsFromMeAppStore = L10n.tr("Localizable", "more_apps_from_me_app_store")
  /// New apps
  static let newApps = L10n.tr("Localizable", "new_apps")
  /// Open in App Store
  static let openInAppStore = L10n.tr("Localizable", "open_in_app_store")
  /// Privacy Policy
  static let privacyPolicy = L10n.tr("Localizable", "privacy_policy")
  /// Rate Us
  static let rateUs = L10n.tr("Localizable", "rate_us")
  /// Send feedback
  static let sendFeedback = L10n.tr("Localizable", "send_feedback")
  /// Settings
  static let settings = L10n.tr("Localizable", "settings")
  /// Support
  static let support = L10n.tr("Localizable", "support")
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
