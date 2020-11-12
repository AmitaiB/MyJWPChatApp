//
//  Codable+extensions.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/6/20.
//

import Foundation

/**
 Unused in favor of CodableFirebase pod -- but retaining this as a fallback.
 */
//extension Decodable {
//    init(decodeFrom source: Any) throws {
//        let data = try JSONSerialization.data(withJSONObject: source, options: .prettyPrinted)
//        self = try JSONDecoder().decode(Self.self, from: data)
//    }
//
//    init?(decodeFrom source: Any?) throws {
//        guard let source = source else { return nil }
//        try self.init(decodeFrom: source)
//    }
//}
