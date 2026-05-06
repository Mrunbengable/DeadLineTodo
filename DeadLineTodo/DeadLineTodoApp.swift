//
//  DeadLineTodoApp.swift
//  DeadLineTodo
//
//  Created by Andy on 2024/1/17.
//  Refactored with modern Swift and MVVM architecture
//

import SwiftUI
@preconcurrency import SwiftData
import TipKit

// MARK: - Type Aliases

typealias TodoData = TodoDataSchemaV9.TodoData
typealias UserSetting = TodoDataSchemaV9.UserSetting

// MARK: - App Entry Point

@main
struct DeadLineTodoApp: App {
    
    let container: ModelContainer
    @StateObject private var store = StoreKitManager()
    @State private var updated = false
    
    init() {
        do {
            try Tips.configure()
            
            let config = ModelConfiguration(
                "TodoData",
                schema: Schema([TodoData.self, UserSetting.self])
            )
            
            container = try ModelContainer(
                for: TodoData.self, UserSetting.self,
                migrationPlan: TodoDataMigrationPlan.self,
                configurations: config
            )
        } catch {
            print("初始化模型容器时发生错误：\(error)")
            fatalError("Failed to initialize model container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(updated: $updated)
                .environmentObject(store)
        }
        .modelContainer(container)
    }
}
