// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  /// Add
  internal static let actionAddTitle = Strings.tr("Localizable", "actionAddTitle")
  /// OK
  internal static let actionOkTitle = Strings.tr("Localizable", "actionOkTitle")
  /// Save
  internal static let actionSaveTitle = Strings.tr("Localizable", "actionSaveTitle")
  /// Card Number
  internal static let cardDetailCardNumberPlaceholder = Strings.tr("Localizable", "cardDetailCardNumberPlaceholder")
  /// Enter name
  internal static let cardDetailEnterNamePlaceholder = Strings.tr("Localizable", "cardDetailEnterNamePlaceholder")
  /// Create
  internal static let createModeTitle = Strings.tr("Localizable", "createModeTitle")
  /// Edit
  internal static let editModeTitle = Strings.tr("Localizable", "editModeTitle")
  /// About app
  internal static let leftMenuAboutApp = Strings.tr("Localizable", "leftMenuAboutApp")
  /// Change profile
  internal static let leftMenuChangeProfile = Strings.tr("Localizable", "leftMenuChangeProfile")
  /// Login
  internal static let loginButton = Strings.tr("Localizable", "loginButton")
  /// Don't have an account?
  internal static let loginSubtitle = Strings.tr("Localizable", "loginSubtitle")
  /// Welcome to CardsBox 👋
  internal static let loginTitle = Strings.tr("Localizable", "loginTitle")
  /// Logout
  internal static let logoutButton = Strings.tr("Localizable", "logoutButton")
  /// Add New 💳
  internal static let mainAddNewButton = Strings.tr("Localizable", "mainAddNewButton")
  /// 
  internal static let mainTitle = Strings.tr("Localizable", "mainTitle")
  /// Email
  internal static let placeholderEmail = Strings.tr("Localizable", "placeholderEmail")
  /// Password
  internal static let placeholderPassword = Strings.tr("Localizable", "placeholderPassword")
  /// Username
  internal static let placeholderUsername = Strings.tr("Localizable", "placeholderUsername")
  /// Create new account
  internal static let registerTitle = Strings.tr("Localizable", "registerTitle")
  /// Registration
  internal static let registrationButton = Strings.tr("Localizable", "registrationButton")
  /// Sign Up
  internal static let signUpButton = Strings.tr("Localizable", "signUpButton")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
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
