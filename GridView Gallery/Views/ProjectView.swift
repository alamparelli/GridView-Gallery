//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ProjectView: View {
    @Environment(DatabaseService.self) var db
    var project: Project
    
    var body: some View {
        if db.projectImages(project).isEmpty {
            ContentUnavailableView {
                PhotoPickerView()
            } description: {
                Text("Nothing to Show yet")
            }
        } else {
            StaggeredList(images: db.projectImages(project))
        }
    }
}

#Preview {
    ProjectView(project: Project())
}
