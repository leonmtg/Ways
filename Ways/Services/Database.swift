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
    var modelContainer: () -> ModelContainer
    var modelContext: () -> ModelContext
}

extension Database: DependencyKey {
    static let liveValue = Self(
        modelContainer: { directoryModelContainer },
        modelContext: { directoryModelContext }
    )
    static let previewValue = Self(
        modelContainer: { onlyMemoryContainer },
        modelContext: { onlyMemoryContext }
    )
    static let testValue = Self(
        modelContainer: { onlyMemoryContainer },
        modelContext: { onlyMemoryContext }
    )
}

extension DependencyValues {
    var database: Database {
        get { self[Database.self] }
        set { self[Database.self] = newValue }
    }
}

fileprivate let directoryModelContainer: ModelContainer = {
    do {
        let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
        let config = ModelConfiguration(url: url)
        let container = try ModelContainer(for: schema, configurations: config)
        return container
    } catch {
        fatalError("Failed to create container.")
    }
}()

fileprivate let directoryModelContext: ModelContext = {
    return ModelContext(directoryModelContainer)
}()

private let onlyMemoryContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: config)
        return container
    } catch {
        fatalError("Failed to create container.")
    }
}()

private let onlyMemoryContext: ModelContext = {
    return ModelContext(onlyMemoryContainer)
}()

fileprivate let schema: Schema = {
    Schema([Way.self, Tag.self, User.self])
}()
