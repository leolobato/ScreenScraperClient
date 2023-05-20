//
//  GameRom.swift
//  
//
//  Created by Leonardo Lobato on 24/04/23.
//

import Foundation

public struct GameRom: Decodable {

    public let id: String
    public let size: UInt64?
    public let filename: String

    public let hash: [FileIdentifier]

    public enum CodingKeys: String, CodingKey {
        case id
        case size = "romsize"
        case filename = "romfilename"
        case hashCrc = "romcrc"
        case hashMd5 = "rommd5"
        case hashSha1 = "romsha1"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.size = try UInt64(container.decode(String.self, forKey: .size))
        self.filename = try container.decode(String.self, forKey: .filename)

        var hash = [FileIdentifier]()
        if let crc = try container.decodeIfPresent(String.self, forKey: .hashCrc) {
            hash.append(.crc(crc.lowercased()))
        }
        if let md5 = try container.decodeIfPresent(String.self, forKey: .hashMd5) {
            hash.append(.md5(md5.lowercased()))
        }
        if let sha1 = try container.decodeIfPresent(String.self, forKey: .hashSha1) {
            hash.append(.sha1(sha1.lowercased()))
        }
        self.hash = hash
    }
}
