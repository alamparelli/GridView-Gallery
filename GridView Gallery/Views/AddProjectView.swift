//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct AddProjectView: View {
    @Environment(DatabaseService.self) var db
    @State private var project = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Project Name", text: $project)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.accent, lineWidth: 1)
                    }
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
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        db.addProject(Project(name: project))
                        dismiss()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .tint(.accent)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    AddProjectView()
}
