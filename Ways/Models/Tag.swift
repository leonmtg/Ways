//
//  Tag.swift
//  Ways
//
//  Created by Leon on 2023/12/21.
//

import Foundation
import SwiftData

enum Metatag: String, Codable {
    case VARK = "vark" // For visual, aural, read/write, kinesthetic
    case Way = "way" // For app, course, book, news source, website
    case Level = "level" // For A1, A2, B1, B2, C1, C2
    case Age = "age" // For Adult, Child
    case Platform = "platform" // For iOS, Android, macOS, Windows
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
