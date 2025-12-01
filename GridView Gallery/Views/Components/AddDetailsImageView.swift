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
                Picker(selection: $project) {
                    Text("None")
                        .tag(nil as Project?)
                    ForEach(db.projects.sorted()) { project in
                        Text(project.unwrappedName)
                            .tag(project as Project?)
                    }
                } label: {
                    Text("Choose a Project")
//                        .foregroundStyle(.strokeBorder)
                }
                .pickerStyle(.navigationLink)
                .font(.subheadline)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.strokeBorder, lineWidth: 1)
                }
            }
            
            TagsView(image: $imageItem, showEditDetails: showEditDetails)
            
            VStack (alignment: .leading) {
                Text("Description")
                    .fontWeight(.semibold)
                
                TextEditor(text: $description)
                    .font(.subheadline)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.strokeBorder, lineWidth: 1)
                    }
            }
        }
    }
}
