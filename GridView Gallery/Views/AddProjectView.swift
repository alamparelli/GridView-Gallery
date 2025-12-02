//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// Simple sheet for creating a new project.
struct AddProjectView: View {
    @Environment(DatabaseService.self) var db

    /// Project name text field.
    @State private var project = ""

    @Environment(\.dismiss) var dismiss

    /// Automatically focuses the text field on appear.
    @FocusState private var isFocused: Bool
        
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Project Name", text: $project)
                    .focused($isFocused)
                    .onAppear {
                        isFocused.toggle()
                    }
                    .onSubmit {
                        db.addProject(Project(name: project))
                        dismiss()
                    }
                    .padding()
                    .overlayModifierRounded()
            }
            .glassEffect()
            .padding()
            .navigationTitle("Add Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button{
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage:  "xmark")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.accent)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        db.addProject(Project(name: project))
                        dismiss()
                    } label: {
                        Label("Add project", systemImage:  "square.and.arrow.down")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.accent)
                    }
                    .tint(.accentColorInverted)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

