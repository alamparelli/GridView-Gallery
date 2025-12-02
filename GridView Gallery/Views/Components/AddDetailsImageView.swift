//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct AddDetailsImageView: View {
    @Environment(DatabaseService.self) var db
    
    @Binding var imageItem: ImageItem?
    
    @Binding var project: Project?
    @Binding var description: String
    
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
