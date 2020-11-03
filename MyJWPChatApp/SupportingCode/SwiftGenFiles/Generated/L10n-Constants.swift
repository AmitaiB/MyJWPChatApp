// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
  internal static let bigBuckBunnyURL = L10n.tr("localizable", "Big Buck Bunny URL")
  /// http://playertest.longtailvideo.com/adaptive/bipbop/gear4/prog_index.m3u8
  internal static let bipBopURL = L10n.tr("localizable", "Bip Bop URL")
  /// Linear
  internal static let linear = L10n.tr("localizable", "Linear")
  /// Non-Linear
  internal static let nonLinear = L10n.tr("localizable", "NonLinear")

  internal enum JWAdBreak {
    /// JWAdBreakCell
    internal static let cell = L10n.tr("localizable", "JWAdBreak.Cell")
  }

  internal enum JWAdClient {
    /// FreeWheel
    internal static let freewheel = L10n.tr("localizable", "JWAdClient.Freewheel")
    /// Google IMA
    internal static let googima = L10n.tr("localizable", "JWAdClient.Googima")
    /// VAST
    internal static let vast = L10n.tr("localizable", "JWAdClient.Vast")
  }

  internal enum JWAdShown {
    /// None
    internal static let `none` = L10n.tr("localizable", "JWAdShown.None")
    /// Pre
    internal static let pre = L10n.tr("localizable", "JWAdShown.Pre")
  }

  internal enum Row {
    /// adClientSelectionRow
    internal static let adClientSelection = L10n.tr("localizable", "row.adClientSelection")
    /// subConfigSelectionRow
    internal static let subConfigSelectionRow = L10n.tr("localizable", "row.subConfigSelectionRow")
  }

  internal enum Seg {
    /// Advertising
    internal static let advertising = L10n.tr("localizable", "seg.advertising")
    /// Content
    internal static let content = L10n.tr("localizable", "seg.content")
    /// UI
    internal static let ui = L10n.tr("localizable", "seg.ui")
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
