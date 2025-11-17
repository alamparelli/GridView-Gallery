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
                            ProjectSquareView(project: project, images: db.projectImages(project))
                        }
                    }
                    .padding()
                }
                .animation(.default, value: db.projects)
                .scrollBounceBehavior(.basedOnSize)
                .scrollIndicators(.never)
            }
        }
        .navigationTitle("Projects")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            Button {
                showAddProject = true
            } label: {
                Label("Add a project", systemImage: "plus.rectangle.on.folder")
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
