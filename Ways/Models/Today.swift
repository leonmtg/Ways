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

enum Entry: Codable {
    case promotion(Promotion)
    case promotions(Promotions)
    
    enum PredictKey: String, CodingKey {
        case type
    }
    
    enum TargetObjectType: String, Decodable {
        case promotion
        case promotions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PredictKey.self)
        let singleValueContainer = try decoder.singleValueContainer()
        let targetObjectType = try container.decode(TargetObjectType.self, forKey: .type)
        
        switch targetObjectType {
        case .promotion:
            let promotion = try singleValueContainer.decode(Promotion.self)
            self = .promotion(promotion)
        case .promotions:
            let promotions = try singleValueContainer.decode(Promotions.self)
            self = .promotions(promotions)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        
        switch self {
        case .promotion(let p):
            try singleContainer.encode(p)
        case .promotions(let ps):
            try singleContainer.encode(ps)
        }
    }
}
