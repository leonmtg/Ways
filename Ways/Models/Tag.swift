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
}
