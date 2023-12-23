//
//  TagContext.swift
//  Ways
//
//  Created by Leon on 2023/12/23.
//

import Foundation
import SwiftData
import Dependencies

struct TagContext {
    var fetchAll: @Sendable () throws -> [Tag]
    var fetch: @Sendable (FetchDescriptor<Tag>) throws -> [Tag]
    var add: @Sendable (Tag) throws -> Void
    var delete: @Sendable (Tag) throws -> Void
    
    enum TagError: Error {
        case add
        case delete
    }
}

extension TagContext: DependencyKey {
    static let liveValue: TagContext = Self(
        fetchAll: {
            do {
                @Dependency(\.database) var database
                let context = try database.modelContext()
                
                let descriptor = FetchDescriptor<Tag>(sortBy: [SortDescriptor(\.name)])
                return try context.fetch(descriptor)
            } catch {
                return []
            }
        },
        
        fetch: { descriptor in
            do {
                @Dependency(\.database) var database
                let context = try database.modelContext()
                
                return try context.fetch(descriptor)
            } catch {
                return []
            }
        },
        
        add: { way in
            do {
                @Dependency(\.database) var database
                let context = try database.modelContext()
                
                context.insert(way)
            } catch {
                throw TagError.add
            }
        },
        
        delete: { way in
            do {
                @Dependency(\.database) var database
                let context = try database.modelContext()
                
                let modelToBeDelete = way
                context.delete(modelToBeDelete)
            } catch {
                throw TagError.delete
            }
        }
    )
}

extension DependencyValues {
    var tagContext: TagContext {
        get { self[TagContext.self] }
        set { self[TagContext.self] = newValue }
    }
}
