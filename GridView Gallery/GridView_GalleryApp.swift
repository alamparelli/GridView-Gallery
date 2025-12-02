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
    
    /// User's preferred theme setting stored persistently
    @AppStorage("GridViewTheme") private var selectedTheme: String = "Dynamic"
    
    /**
     Computed property that converts the string-based theme preference to SwiftUI's ColorScheme.
     
     - Returns: Optional ColorScheme based on user preference
       - "Light": Returns .light for light mode
       - "Dark": Returns .dark for dark mode
       - "Dynamic" or any other value: Returns .none for system preference
     */
    var themeChoosen: ColorScheme? {
        switch selectedTheme {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return .none
        }
    }

    var body: some Scene {
        WindowGroup {
            TabControllerView(ns: navigation)
                .preferredColorScheme(themeChoosen)
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
