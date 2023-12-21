//
//  Database.swift
//  Ways
//
//  Created by Leon on 2023/12/21.
//

import Foundation
import SwiftData
import Dependencies

struct Database {
    var modelContext: () throws -> ModelContext
}

extension Database: DependencyKey {
    static let liveValue = Self(
        modelContext: {
            do {
                let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
                let config = ModelConfiguration(url: url)
                let container = try ModelContainer(for: Way.self, Tag.self, configurations: config)
                return ModelContext(container)
            } catch {
                fatalError("Failed to create container.")
            }
        }
    )
}

extension DependencyValues {
    var database: Database {
        get { self[Database.self] }
        set { self[Database.self] = newValue }
    }
}
