//
//  Media.swift
//  
//
//  Created by Leonardo Lobato on 16/04/23.
//

import Foundation

public struct Media: Codable, OptionalRegionEnabled {
    public let type: String
    public let parent: String
    public let region: String?

    public let url: String
    public let format: String
}
