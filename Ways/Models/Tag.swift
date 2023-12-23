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
    
    init(name: String) {
        self.name = name
    }
}
