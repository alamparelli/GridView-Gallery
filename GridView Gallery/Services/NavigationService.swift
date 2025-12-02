//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

enum Destination: Hashable {
    case gallery
    case projects
    case project(Project)
    case settings
    case search
    case imageDetails(ImageItem, [ImageItem])
    }

@Observable
class NavigationService {
    var path = NavigationPath()
    
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
    
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
