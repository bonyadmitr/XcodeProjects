// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// All
  static let all = L10n.tr("Localizable", "all")
  /// Bold
  static let bold = L10n.tr("Localizable", "bold")
  /// Cancel
  static let cancel = L10n.tr("Localizable", "cancel")
  /// Colors
  static let colors = L10n.tr("Localizable", "colors")
  /// Default
  static let `default` = L10n.tr("Localizable", "default")
  /// Fonts
  static let fonts = L10n.tr("Localizable", "fonts")
  /// Light
  static let light = L10n.tr("Localizable", "light")
  /// Enter new city
  static let newCity = L10n.tr("Localizable", "new_city")
  /// Not found
  static let notFound = L10n.tr("Localizable", "not_found")
  /// Pull to refresh
  static let pullRefresh = L10n.tr("Localizable", "pull_refresh")
  /// Regular
  static let regular = L10n.tr("Localizable", "regular")
  /// Search
  static let search = L10n.tr("Localizable", "search")
  /// Select color
  static let selectColor = L10n.tr("Localizable", "select_color")
  /// Select font
  static let selectFont = L10n.tr("Localizable", "select_font")
  /// Select language
  static let selectLanguage = L10n.tr("Localizable", "select_language")
  /// Settings
  static let settings = L10n.tr("Localizable", "settings")
  /// Weather App
  static let weatherApp = L10n.tr("Localizable", "weather_app")
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
