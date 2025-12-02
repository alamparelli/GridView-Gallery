//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// Form section for editing image metadata (project, tags, description).
struct AddDetailsImageView: View {
    @Environment(DatabaseService.self) var db

    /// Image being edited.
    @Binding var imageItem: ImageItem?

    /// Selected project.
    @Binding var project: Project?

    /// Image description text.
    @Binding var description: String

    /// Whether details editing is enabled.
    @State private var showEditDetails = true
    
    var body: some View {
        Section {
            if !db.projects.isEmpty {
                PickerProjectView(project: $project, text: "None")
            }
            
            TagsView(image: $imageItem, showEditDetails: showEditDetails)
            
            VStack (alignment: .leading) {
                Text("Description")
                    .fontWeight(.semibold)
                
                TextEditor(text: $description)
                    .font(.subheadline)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .overlayModifierRounded()
            }
        }
    }
}
