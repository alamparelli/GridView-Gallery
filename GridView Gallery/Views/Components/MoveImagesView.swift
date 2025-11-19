//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct MoveImagesView: View {
    @Environment(DatabaseService.self) var db
    @Environment(\.dismiss) var dismiss
    
    @State private var project: Project?
    @State private var showAddProject = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $project) {
                    Text("Create new")
                        .tag(nil as Project?)
                    ForEach(db.projects.sorted()) { project in
                        Text(project.unwrappedName)
                            .tag(project as Project?)
                    }
                } label: {
                    Text("Choose a Project")
                        .foregroundStyle(.strokeBorder)
                }
                .pickerStyle(.navigationLink)
                .font(.subheadline)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.strokeBorder, lineWidth: 1)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Move images to")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddProject, onDismiss: {
                db.updateProjectImage()
                dismiss()
            }) {
                AddProjectView()
                    .presentationDetents([.fraction(0.25)])
            }
            .toolbar {
                Button{
                    if project == nil {
                        // show add project and at completion set project as the new created
                        showAddProject = true
                    } else {
                        // update the project for selected images
                        db.projectToUpdate = project
                        db.updateProjectImage()
                        dismiss()
                    }
                } label: {
                    Label("Move", systemImage: "square.and.arrow.down")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.accent)
                }
                .tint(.accentColorInverted)
                .buttonStyle(.borderedProminent)
            }
        }
    }

}

#Preview {
    MoveImagesView()
}
