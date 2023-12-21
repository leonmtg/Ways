//
//  WayContext.swift
//  Ways
//
//  Created by Leon on 2023/12/21.
//

import Foundation
import SwiftData
import Dependencies

struct WayContext {
    var fetchAll: @Sendable () throws -> [Way]
    var fetch: @Sendable (FetchDescriptor<Way>) throws -> [Way]
    var add: @Sendable (Way) throws -> Void
    var delete: @Sendable (Way) throws -> Void
    
    enum WayError: Error {
        case add
        case delete
    }
}

extension WayContext: DependencyKey {
    static let liveValue: WayContext = Self(
        fetchAll: {
            do {
                @Dependency(\.database) var database
                let context = try database.modelContext()
                
                let descriptor = FetchDescriptor<Way>(sortBy: [SortDescriptor(\.name)])
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
                throw WayError.add
            }
        },
        
        delete: { way in
            do {
                @Dependency(\.database) var database
                let context = try database.modelContext()
                
                let modelToBeDelete = way
                context.delete(modelToBeDelete)
            } catch {
                throw WayError.delete
            }
        }
    )
}

extension DependencyValues {
    var wayContext: WayContext {
        get { self[WayContext.self] }
        set { self[WayContext.self] = newValue }
    }
}
