//
//  Way.swift
//  Ways
//
//  Created by Leon on 2023/12/21.
//

import Foundation
import SwiftData

@Model
final class Way {
    var name: String
    // Prevent from too many Tags
    @Relationship(maximumModelCount: 10, inverse: \Tag.ways) var tags: [Tag]
    
    init(name: String, tags: [Tag]) {
        self.name = name
        self.tags = tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        tags = try container.decode([Tag].self, forKey: .tags)
    }
}

extension Way: Codable {
    enum CodingKeys: CodingKey {
        case name
        case tags
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(tags, forKey: .tags)
    }
}
