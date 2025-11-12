//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct GridView_GalleryApp: App {
    @State private var navigation = NavigationService()
    
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
            NavigationStack(path: $navigation.path) {
                ContentView()
            }
            .navigationDestination(for: Destination.self) { destination in
                navigation.returnView(destination)
            }
        }
        .environment(navigation)
        .environment(database)
        .modelContainer(modelContainer)
    }
}
