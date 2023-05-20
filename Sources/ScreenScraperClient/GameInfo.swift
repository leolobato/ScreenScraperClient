//
//  GameInfo.swift
//  
//
//  Created by Leonardo Lobato on 24/04/23.
//

import Foundation

public struct GameInfo: Decodable {
    public let id: String
    public let romId: String?

    public let names: [RegionEnabledText]
    public let roms: [GameRom]
    public let description: [LanguageEnabledText]
    public let medias: [Media]
    public let platform: String?
    public let publisher: String?
    public let developer: String?
    public let players: String?
    public let genres: [Genre]
    public let releaseDate: [RegionEnabledText]

    public enum CodingKeys: String, CodingKey {
        case id
        case romId = "romid"
        case names = "noms"
        case roms
        case description = "synopsis"
        case medias
        case platform = "systeme"
        case publisher = "editeur"
        case developer = "developpeur"
        case players = "joueurs"
        case genres = "genres"
        case releaseDate = "dates"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.romId = try container.decodeIfPresent(String.self, forKey: .romId)
        self.names = try container.decode([RegionEnabledText].self, forKey: .names)
        self.description = try container.decodeIfPresent([LanguageEnabledText].self, forKey: .description) ?? []
        self.medias = try container.decode([Media].self, forKey: .medias)

        self.platform = try container.decode([String: String].self, forKey: .platform)["text"]
        self.publisher = try container.decodeIfPresent([String: String].self, forKey: .publisher)?["text"]
        self.developer = try container.decodeIfPresent([String: String].self, forKey: .developer)?["text"]
        self.players = try container.decodeIfPresent([String: String].self, forKey: .players)?["text"]

        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres) ?? []
        self.releaseDate = try container.decodeIfPresent([RegionEnabledText].self, forKey: .releaseDate) ?? []

        self.roms = try container.decodeIfPresent([GameRom].self, forKey: .roms) ?? []
    }

    public func rom() -> GameRom? {
        for rom in self.roms {
            if rom.id == self.romId { return rom }
        }
        return nil
    }

    public func mediaTypes() -> [String] {
        var keys = [String]()
        for media in self.medias {
            let type = media.type
            if !keys.contains(type) {
                keys.append(type)
            }
        }
        return keys
    }
    public func media(_ type: String) -> [Media] {
        let medias = self.medias.filter({ $0.type == type })
        return medias
    }

}
