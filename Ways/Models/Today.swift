//
//  Today.swift
//  Ways
//
//  Created by Leon on 2024/1/25.
//

import Foundation

struct Today: Decodable {
    let entries: [Entry]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.entries = try container.decode([Entry].self)
    }
}

enum Entry: Decodable {
    case promotion(Promotion)
    case promotions(Promotions)
    
    private enum CodingKeys : String, CodingKey {
        case promotion
        case promotions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self = .promotion(try container.decode(Promotion.self, forKey: .promotion))
        } catch DecodingError.keyNotFound {
            self = .promotions(try container.decode(Promotions.self, forKey: .promotions))
        }
    }
}
