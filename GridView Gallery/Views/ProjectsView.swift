//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ProjectsView: View {
    @State private var showAddProject: Bool = false
    @Environment(DatabaseService.self) var db
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            if db.projects.isEmpty {
                ContentUnavailableView {
                    Button {
                        showAddProject = true
                    } label: {
                        Label("Add a project", systemImage: "plus.rectangle.on.folder")
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
            ToolbarItem {
                Button {
                    showAddProject = true
                } label: {
                    Label("Add a project", systemImage: "plus.rectangle.on.folder")
                }
            }
            ToolbarItem {
                //Debug
                Button("Delete") {
                    for pr in db.projects {
                        db.removeProject(pr)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddProject) {
            AddProjectView()
                .presentationDetents([.fraction(0.25)])
        }
    }
}

#Preview {
    ProjectsView()
}
