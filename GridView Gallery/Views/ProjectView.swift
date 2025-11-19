//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ProjectView: View {
    @Environment(DatabaseService.self) var db

    var project: Project
    @State private var projectName: String = ""
    @State private var showAddImage = false
    @State private var searchText: String = ""
    
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
        .onAppear{
            if let pName = project.name {
                projectName = pName
            }
        }
        .onChange(of: projectName) { oldValue, newValue in
            project.name = newValue
            db.editProject()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    showAddImage = true
                } label: {
                    Label("Add a photo", systemImage: "photo.badge.plus")
                }
            }
            ToolbarSpacer(.flexible, placement: .bottomBar)
            DefaultToolbarItem(kind: .search, placement: .bottomBar)
        }
        .sheet(isPresented: $showAddImage) {
            AddImageView(project: project)
        }
    }
}

#Preview {
    ProjectView(project: Project())
}
