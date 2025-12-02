//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct PickerProjectView: View {
    @Binding var project: Project?
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
