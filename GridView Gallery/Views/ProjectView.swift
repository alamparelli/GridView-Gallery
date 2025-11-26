//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ProjectView: View {
    @Environment(DatabaseService.self) var db
    @Environment(\.dismiss) var dismiss

    var project: Project
    @State private var projectName: String = ""
    @State private var showAddImage = false
    @State private var searchText: String = ""
    
    @State private var isEditing = false
    @State private var showMoveView = false
    @State private var showDeleteConfirmation: Bool = false
    
    var projectIsEmpty: Bool {
        project.images?.count == 0
    }
    
    var body: some View {
        VStack {
            if project.images?.count == 0 {
                ContentUnavailableView {
                    //
                } description: {
                    Text("Nothing to Show yet")
                }
            } else {
                StaggeredList(images: project.images!)
                    .searchable(text: $searchText, prompt: "Search for a photo")
                    .searchToolbarBehavior(.minimize)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle($projectName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !projectIsEmpty {
                ToolbarItem {
                    Button(db.isEditing ? "Done" : "Edit" , systemImage: db.isEditing ? "checkmark" : "pencil") {
                        db.isEditing.toggle()
                        db.resetSelectedImagesWhenEditingList()
                    }
                }
            }
            
            ToolbarSpacer(.flexible)
            
            if !db.isEditing {
                ToolbarItem {
                    Button {
                        showAddImage = true
                    } label: {
                        Label("Add a photo", systemImage: "photo.badge.plus")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        
            if db.isEditing && !db.selectedImagesWhenEditingList.isEmpty {
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
                        Text("Are you sure to delete this note?")
                    }
                }
                ToolbarItem {
                    Button("Move", systemImage: "arrow.forward.folder", role: .destructive) {
                        showMoveView = true
                    }
                }
            }
            
            ToolbarSpacer(.flexible, placement: .bottomBar)
            DefaultToolbarItem(kind: .search, placement: .bottomBar)
        }
        .onChange(of: project.images) {
            if projectIsEmpty {
                db.isEditing = false
            }
        }
        .onDisappear {
            db.isEditing = false
        }
        .onAppear{
            if let pName = project.name {
                projectName = pName
            }
        }
        .onChange(of: projectName) { oldValue, newValue in
            project.name = newValue
            db.editProject()
        }
        .animation(.bouncy, value: db.isEditing)
        .sheet(isPresented: $showMoveView) {
            MoveImagesView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showAddImage) {
            AddImageView(project: project)
        }
    }
}

//#Preview {
//    ProjectView(project: Project())
//}
