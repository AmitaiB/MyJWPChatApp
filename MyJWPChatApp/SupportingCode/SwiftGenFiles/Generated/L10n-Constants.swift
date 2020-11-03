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

  internal enum Mock {
    internal enum User {
      internal enum Amitai {
        /// amitai@jwplayer.com
        internal static let email = L10n.tr("localizable", "Mock.User.Amitai.Email")
        /// openopen
        internal static let password = L10n.tr("localizable", "Mock.User.Amitai.Password")
      }
      internal enum Andrea {
        /// atempestini@jwplayer.com
        internal static let email = L10n.tr("localizable", "Mock.User.Andrea.Email")
        /// atempestini
        internal static let password = L10n.tr("localizable", "Mock.User.Andrea.Password")
      }
    }
  }

  internal enum ReuseID {
    /// ChatCellReuseID
    internal static let chatCell = L10n.tr("localizable", "ReuseID.ChatCell")
    /// ProfileCellReuseID
    internal static let profileCell = L10n.tr("localizable", "ReuseID.ProfileCell")
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
