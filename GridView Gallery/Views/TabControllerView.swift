//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct TabControllerView: View {
    @State private var selectedTab = Destination.gallery
    @Bindable var ns : NavigationService
    
    @ViewBuilder
    func NavigationView(_ destination: Destination) -> some View {
        NavigationStack(path: $ns.path) {
            selectView(for: destination)
                .navigationDestination(for: Destination.self) { destination in
                    ns.returnView(destination)
                }
        }
    }
    
    @ViewBuilder
    private func selectView(for destination: Destination) -> some View {
        switch destination {
        case .gallery:
            ContentView()
        case .projects:
            ProjectsView()
        case .settings:
            SettingsView()
        case .search:
            SearchView()
        default:
            EmptyView()
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Gallery", systemImage: "photo.on.rectangle.angled", value: .gallery) {
                NavigationView(.gallery)
            }
            Tab("Projects", systemImage: "list.bullet.rectangle", value: .projects) {
                NavigationView(.projects)
            }
            Tab("Settings", systemImage: "gear", value: .settings) {
                NavigationView(.settings)
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: .search, role: .search) {
                NavigationView(.search)
            }
        }
    }
}

//#Preview {
//    TabControllerView()
//}
