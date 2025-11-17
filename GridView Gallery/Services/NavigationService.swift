//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

enum Destination: Hashable {
    case gallery
    case projects
    case settings
    case search
    case debug
    case addImage
    // fill other depending your needs
}

@Observable
class NavigationService {
    var path = NavigationPath()
    
    @ViewBuilder
    func returnView(_ destination : Destination) -> some View {
        switch destination {
        case .gallery:
            ContentView()
        case .projects:
            ProjectsView()
        case .settings:
            SettingsView()
        case .search:
            SearchView()
        case .debug:
            DebugView()
        case .addImage:
            AddImageView()
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

/// Usage
/// In App.swift
/// Not needed to add NavigationStack in sub views
/* SETUP
 import SwiftUI
 
 @main
 struct App: App {
 @State private var navigation = NavigationService()
 
 var body: some Scene {
 WindowGroup {
 NavigationStack(path: $navigation.path) {
 ContentView()
 .navigationDestination(for: Destination.self) { destination in
 navigation.returnView(destination)
 }
 }
 .environment(navigation)
 }
 }
 }
 */

/* USAGE on sub Views
 Button("Main") {
 navigation.navigate(to: Destination.main)
 }
 
 NavigationLink(value: Destination.main) {
 Text("Main")
 }
 */
