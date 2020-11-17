//
//  Foundation+extensions.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/16/20.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        switch self {
            case .none:
                return true
            case .some(let string):
                return string.isEmpty
        }
    }
}
