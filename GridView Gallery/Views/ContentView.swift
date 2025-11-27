//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    @Environment(\.dismiss) var dismiss
    
    @State private var showPicker = false
    @State private var showAddImage = false
    
    @State private var showDebug = false
    
    @State private var showMoveView = false
    @State private var showDeleteConfirmation: Bool = false
        
    var body: some View {
        VStack {
            if db.images.isEmpty {
                ContentUnavailableView {
                    Button {
                        showAddImage = true
                    } label: {
                        Label("Add a photo", systemImage: "photo.badge.plus")
                            .labelStyle(.iconOnly)
                    }
                } description: {
                    Text("Nothing to Show yet")
                }
            } else {
                StaggeredList(images: db.images)
            }
        }
        .toolbar {
//            #if DEBUG
//            ToolbarItem {
//                Button("Debug", systemImage: "flame") {
//                    showDebug = true
//                }
//            }
//            #endif
            
            if !db.images.isEmpty {
                ToolbarItem {
                    Button(db.isEditingImages ? "Done" : "Edit" , systemImage: db.isEditingImages ? "checkmark" : "pencil") {
                        db.isEditingImages.toggle()
                        db.resetSelectedImagesWhenEditingList()
                    }
                }
            }
            
            ToolbarSpacer(.flexible)
            
            if !db.isEditingImages {
                ToolbarItem {
                    Button {
                        showAddImage = true
                    } label: {
                        Label("Add a photo", systemImage: "photo.badge.plus")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        
            if db.isEditingImages && !db.selectedImagesWhenEditingList.isEmpty {
                ToolbarItem {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                    .confirmationDialog("Delete Images", isPresented: $showDeleteConfirmation) {
                        Button ("Delete", role: .destructive) {
                            db.removeImageItems(db.selectedImagesWhenEditingList)
                        }
                        Button("Not now", role: .cancel) {
                            dismiss()
                        }
                    } message: {
                        Text("Are you sure to delete this image?")
                    }
                }
                ToolbarItem {
                    Button("Move", systemImage: "arrow.forward.folder", role: .destructive) {
                        showMoveView = true
                    }
                }
            }
        }
        .onChange(of: db.images) {
            if db.images.isEmpty {
                db.isEditingImages = false
            }
        }
        .onDisappear {
            db.isEditingImages = false
        }
        .animation(.bouncy, value: db.isEditingImages)
        .navigationTitle("Home")
        .sheet(isPresented: $showAddImage) {
            AddImageView()
        }
        .sheet(isPresented: $showMoveView) {
            MoveImagesView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showDebug) {
            DebugView()
        }
    }
}

//#Preview {
//    ContentView()
//}
