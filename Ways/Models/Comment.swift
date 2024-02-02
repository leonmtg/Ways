//
//  Comment.swift
//  Ways
//
//  Created by Leon on 2024/1/16.
//

import Foundation
import SwiftData

@Model
final class Comment {
    var id: UUID
    var score: Int
    var subject: String
    var comment: String
    var commenter: String
    var date: Date
    
    init(score: Int, subject: String, date: Date, comment: String, commenter: String) {
        self.id = UUID()
        self.score = score
        self.subject = subject
        self.date = date
        self.comment = comment
        self.commenter = commenter
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        score = try container.decode(Int.self, forKey: .score)
        subject = try container.decode(String.self, forKey: .subject)
        comment = try container.decode(String.self, forKey: .comment)
        commenter = try container.decode(String.self, forKey: .commenter)
        date = try container.decode(Date.self, forKey: .date)
    }
}

extension Comment: Codable {
    enum CodingKeys: CodingKey {
        case id
        case score
        case subject
        case comment
        case commenter
        case date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(score, forKey: .score)
        try container.encode(subject, forKey: .subject)
        try container.encode(comment, forKey: .comment)
        try container.encode(commenter, forKey: .commenter)
        try container.encode(date, forKey: .date)
    }
}
