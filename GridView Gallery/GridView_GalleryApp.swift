//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

/// Main app entry point managing theme, navigation, and database services.
@main
struct GridView_GalleryApp: App {
    /// Navigation service for app-wide routing.
    @State private var navigation = NavigationService()

    /// Current app lifecycle phase.
    @Environment(\.scenePhase) var scenePhase

    /// Database service for data operations.
    var database: DatabaseService

    /// SwiftData model container.
    let modelContainer: ModelContainer

    /// Initializes SwiftData and database service.
    init() {
        let schema = Schema([ImageItem.self])
        
        do {
            modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Cannot setup SwiftData")
        }
        
        database = DatabaseService(context: modelContainer.mainContext)
    }
    
    /// User's preferred theme setting stored persistently.
    @AppStorage("GridViewTheme") private var selectedTheme: String = "Dynamic"

    /// Converts the string theme preference to ColorScheme.
    /// - Returns: `.light`, `.dark`, or `.none` (system default).
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
