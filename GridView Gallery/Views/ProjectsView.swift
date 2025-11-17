//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ProjectsView: View {
    @State private var showAddProject: Bool = false
    
    var body: some View {
        Text("Projects")
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
