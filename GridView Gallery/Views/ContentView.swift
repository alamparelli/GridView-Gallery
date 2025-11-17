//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    
    @State private var showPicker = false
    @State private var showAddImage = false
    
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
            ToolbarItem {
                EditButton()
            }
        }
        .navigationTitle("Home")
        .sheet(isPresented: $showAddImage) {
            AddImageView()
        }
    }
}

#Preview {
    ContentView()
}
