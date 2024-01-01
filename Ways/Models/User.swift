//
//  User.swift
//  Ways
//
//  Created by Leon on 2024/1/1.
//

import Foundation
import SwiftData

@Model
final class User {
    var name: String
    // Prevent from too many Tags
    @Relationship(maximumModelCount: 10) var tags: [Tag]
    
    init(name: String, tags: [Tag]) {
        self.name = name
        self.tags = tags
    }
}
