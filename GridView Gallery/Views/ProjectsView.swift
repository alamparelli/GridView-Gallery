//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// View displaying all projects in a grid layout.
struct ProjectsView: View {
    @State private var showAddProject: Bool = false
    @Environment(DatabaseService.self) var db
    @Environment(NavigationService.self) var ns
    @Environment(\.dismiss) var dismiss

    /// Two-column grid layout.
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    @State private var isEditingProjects = false
    @State private var showMoveView = false

    /// Shows delete confirmation dialog.
    @State private var showDeleteConfirmation: Bool = false

    /// Whether the projects list is empty.
    var isProjectsEmpty: Bool {
        db.projects.isEmpty
    }
    
    var body: some View {
        VStack {
            if isProjectsEmpty {
                ContentUnavailableView {
                    Button {
                        showAddProject = true
                    } label: {
                        Label("Add a project", systemImage: "plus.rectangle.on.folder")
                            .labelStyle(.iconOnly)
                    }
                } description: {
                    Text("Nothing to Show yet")
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(db.projects.sorted()) { project in
                            if let images = project.images {
                                ProjectSquareView(project: project, images: images)
                            }
                        }
                    }
                    .padding()
                }
                .animation(.default, value: db.projects)
                .scrollBounceBehavior(.basedOnSize)
                .scrollIndicators(.never)
            }
        }
        .animation(.default, value: db.projects)
        .navigationTitle("Projects")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            if !isProjectsEmpty {
                ToolbarItem {
                    Button(db.isEditingProjects ? "Done" : "Edit" , systemImage: db.isEditingProjects ? "checkmark" : "pencil") {
                        db.isEditingProjects.toggle()
                        db.resetSelectedProjectsWhenEditingList()
                    }
                }
            }
            
            ToolbarSpacer(.flexible)
            
            if !db.isEditingProjects {
                ToolbarItem {
                    Button {
                        showAddProject = true
                    } label: {
                        Label("Add a project", systemImage: "plus.rectangle.on.folder")
                            .labelStyle(.iconOnly)
                    }
                }
            }
            
            if db.isEditingProjects && !db.selectedProjectsWhenEditingList.isEmpty {
                ToolbarItem {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                    .confirmationDialog("Delete Project", isPresented: $showDeleteConfirmation) {
                        Button ("Delete all", role: .destructive) {
                            db.removeProjects(db.selectedProjectsWhenEditingList, true)
                        }
                        Button ("Only the project", role: .destructive) {
                            db.removeProjects(db.selectedProjectsWhenEditingList)
                        }
                    } message: {
                        Text("Are you sure to delete this project?")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddProject) {
            AddProjectView()
                .presentationDetents([.fraction(0.25)])
        }
        .onDisappear {
            db.isEditingProjects = false
        }
    }
}
