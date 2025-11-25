//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct GridView_GalleryApp: App {
    @State private var navigation = NavigationService()
    @Environment(\.scenePhase) var scenePhase
    
    var database: DatabaseService
    let modelContainer: ModelContainer
    
    init() {
        let schema = Schema([ImageItem.self])
        
        do {
            modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Cannot setup SwiftData")
        }
        
        database = DatabaseService(context: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            TabControllerView(ns: navigation)
//            NavigationStack(path: $navigation.path) {
//                TabControllerView()
//            }
//            .navigationDestination(for: Destination.self) { destination in
//                navigation.returnView(destination)
//            }
        }
        .environment(navigation)
        .environment(database)
        .modelContainer(modelContainer)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                // Refresh data when app becomes active (e.g., returning from share extension)
                database.refreshAll()
            }
        }
    }
}
