//
//  Today.swift
//  Ways
//
//  Created by Leon on 2024/1/25.
//

import Foundation

struct Today: Decodable {
    var title: String?
    var promotables: [any Promotable]
    
    enum CodingKeys: String, CodingKey {
        case title
        case promotables = "promos"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        
        var array = try container.nestedUnkeyedContainer(forKey: .promotables)
        var promotables:[any Promotable] = []
        while !array.isAtEnd {
            if let promotion = try? array.decode(Promotion.self) {
                promotables.append(promotion)
            } else if let promotions = try? array.decode(Promotions.self) {
                promotables.append(promotions)
            }
        }
        self.promotables = promotables
    }
}

protocol Promotable { }

struct Promotions: Promotable, Codable {
    var title: String?
    var subTitle: String?
    var promotions: [Promotion]
}
