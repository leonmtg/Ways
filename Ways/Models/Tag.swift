//
//  Tag.swift
//  Ways
//
//  Created by Leon on 2023/12/21.
//

import Foundation
import SwiftData

enum Metatag: String, Codable {
    case VARK = "vark"
    case Way = "way"
    case Level = "level"
    case Age = "age"
}

@Model
final class Tag {
    var name: String
    var ways: [Way] // No @Reletionship here
    var metatag: Metatag
    
    init(name: String, ways: [Way], metatag: Metatag) {
        self.name = name
        self.ways = ways
        self.metatag = metatag
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        metatag = try container.decode(Metatag.self, forKey: .metatag)
        ways = try container.decode([Way].self, forKey: .ways)
    }
}

extension Tag: Codable {
    enum CodingKeys: CodingKey {
        case name
        case metatag
        case ways
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(metatag, forKey: .metatag)
        try container.encode(ways, forKey: .ways)
    }
}
