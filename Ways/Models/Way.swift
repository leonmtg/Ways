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
}
