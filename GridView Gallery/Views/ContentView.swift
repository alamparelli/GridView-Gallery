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
            if !db.images.isEmpty {
                ToolbarItem {
                    Button(db.isEditing ? "Done" : "Edit" , systemImage: db.isEditing ? "checkmark" : "pencil") {
                        db.isEditing.toggle()
                        db.resetSelectedImagesWhenEditingList()
                    }
                }
            }
            
            if db.isEditing {
                ToolbarItemGroup {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        db.removeImageItems(db.selectedImagesWhenEditingList)
                    }
                }
            }
            
            ToolbarItem {
                Button {
                    showAddImage = true
                } label: {
                    Label("Add a photo", systemImage: "photo.badge.plus")
                }
            }
        }
        .onChange(of: db.images) {
            if db.images.isEmpty {
                db.isEditing = false
            }
        }
        .animation(.bouncy, value: db.isEditing)
        .navigationTitle("Home")
        .sheet(isPresented: $showAddImage) {
            AddImageView()
        }
    }
}

#Preview {
    ContentView()
}
