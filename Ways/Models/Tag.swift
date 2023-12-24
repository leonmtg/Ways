//
//  Tag.swift
//  Ways
//
//  Created by Leon on 2023/12/21.
//

import Foundation
import SwiftData

@Model
final class Tag {
    var name: String
    var ways: [Way]
    var metatag: Metatag
    
    enum Metatag {
        case VARK
        case Way
        case Level
        case Age
    }
    
    init(name: String, ways: [Way], metatag: Metatag) {
        self.name = name
        self.ways = ways
        self.metatag = metatag
    }
}
