// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
internal enum L10n {
    /// All
    internal static let all = L10n.tr("Localizable", "all")
    /// Bold
    internal static let bold = L10n.tr("Localizable", "bold")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "cancel")
    /// Colors
    internal static let colors = L10n.tr("Localizable", "colors")
    /// Default
    internal static let `default` = L10n.tr("Localizable", "default")
    /// Fonts
    internal static let fonts = L10n.tr("Localizable", "fonts")
    /// Light
    internal static let light = L10n.tr("Localizable", "light")
    /// Enter new city
    internal static let newCity = L10n.tr("Localizable", "new_city")
    /// Not found
    internal static let notFound = L10n.tr("Localizable", "not_found")
    /// Pull to refresh
    internal static let pullRefresh = L10n.tr("Localizable", "pull_refresh")
    /// Regular
    internal static let regular = L10n.tr("Localizable", "regular")
    /// Search
    internal static let search = L10n.tr("Localizable", "search")
    /// Select color
    internal static let selectColor = L10n.tr("Localizable", "select_color")
    /// Select font
    internal static let selectFont = L10n.tr("Localizable", "select_font")
    /// Select language
    internal static let selectLanguage = L10n.tr("Localizable", "select_language")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "settings")
    /// Weather App
    internal static let weatherApp = L10n.tr("Localizable", "weather_app")
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
    fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}
