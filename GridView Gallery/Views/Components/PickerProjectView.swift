//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// Navigation picker for selecting a project.
struct PickerProjectView: View {
    /// Selected project binding.
    @Binding var project: Project?

    /// Placeholder text for no selection.
    var text: String

    @Environment(DatabaseService.self) var db
    
    var body: some View {
        Picker(selection: $project) {
            Text(text)
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
        .overlayModifierRounded()
    }
}
