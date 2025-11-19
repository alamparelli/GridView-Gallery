//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    
    @State private var showPicker = false
    @State private var showAddImage = false
    @State private var showDebug = false
    
    var body: some View {
        VStack {
            if db.images.isEmpty {
                ContentUnavailableView {
                    Button {
                        showAddImage = true
                    } label: {
                        Label("Add a photo", systemImage: "photo.badge.plus")
                    }
                } description: {
                    Text("Nothing to Show yet")
                }
            } else {
                StaggeredList(images: db.images)
            }
        }
        .toolbar {
            ToolbarItem {
//                PhotoPickerView()
                Button {
                    showAddImage = true
                } label: {
                    Label("Add a photo", systemImage: "photo.badge.plus")
                }
            }
            ToolbarItem {
                Button("Delete") {
                    db.removeImageItems(db.images)
                }
            }
            #if DEBUG
            ToolbarItem {
                Button("Debug") {
                    showDebug = true
                }
            }
            #endif
        }
        .navigationTitle("Home")
        .sheet(isPresented: $showAddImage) {
            AddImageView()
        }
//        .sheet(isPresented: $showDebug) {
//            DebugView(image: image, images: db.images)
//        }
    }
}

#Preview {
    ContentView()
}
