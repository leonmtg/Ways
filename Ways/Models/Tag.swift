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
    
    init(name: String, ways: [Way]) {
        self.name = name
        self.ways = ways
    }
}
