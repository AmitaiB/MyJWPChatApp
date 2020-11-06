//
//  PostQueryResults.swift
//  MyJWPChatApp
//
//  Created by Amitai Blickstein on 11/5/20.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let postsQueryResult = try PostsQueryResult(json)

import Foundation

// MARK: - PostsQueryResult
struct PostsQueryResult: Codable {
    let username, toID, text: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case toID
        case text
    }
}

// MARK: PostsQueryResult convenience initializers and mutators

extension PostsQueryResult {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PostsQueryResult.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        username: String? = nil,
        toID: String? = nil,
        text: String? = nil
    ) -> PostsQueryResult {
        return PostsQueryResult(
            username: username ?? self.username,
            toID: toID ?? self.toID,
            text: text ?? self.text
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
