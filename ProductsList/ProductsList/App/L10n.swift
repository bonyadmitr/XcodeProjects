// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Created Date
  internal static let createdDate = L10n.tr("Localizable", "created_date")
  /// Name
  internal static let name = L10n.tr("Localizable", "name")

  internal enum ProductsList {
    /// Search name/price/description
    internal static let searchBarPlaceholder = L10n.tr("Localizable", "ProductsList.searchBar_placeholder")
    /// Products
    internal static let title = L10n.tr("Localizable", "ProductsList.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

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
