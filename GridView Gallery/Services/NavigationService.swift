//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

/// Navigation destinations in the app.
enum Destination: Hashable {
    case gallery
    case projects
    case project(Project)
    case settings
    case search
    case imageDetails(ImageItem, [ImageItem])
}

/// Service managing app-wide navigation state.
@Observable
class NavigationService {
    /// The navigation path stack.
    var path = NavigationPath()

    /// Returns the view for a given destination.
    /// - Parameter destination: The destination to display.
    /// - Returns: The corresponding view.
    @ViewBuilder
    func returnView(_ destination : Destination) -> some View {
        switch destination {
        case .gallery: ContentView()
        case .projects: ProjectsView()
        case . project(let project) : ProjectView(project: project)
        case .settings: SettingsView()
        case .search: SearchView()
        case .imageDetails(let image, let images): ImageDetailView(image: image, images: images)
        }
    }

    /// Navigates to a destination.
    /// - Parameter destination: The destination to navigate to.
    func navigate(to destination: Destination) {
        path.append(destination)
    }

    /// Pops the top view from the navigation stack.
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    /// Returns to the root view.
    func popToRoot() {
        path = NavigationPath()
    }
}
