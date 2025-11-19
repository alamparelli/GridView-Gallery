//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct AddDetailsImageView: View {
    @Environment(DatabaseService.self) var db
    @Binding var project: Project?
    @Binding var tags : [Tag]
    @Binding var description: String
    
    var body: some View {
        Section {
            if !db.projects.isEmpty {
                Picker(selection: $project) {
                    Text("None")
                        .foregroundStyle(.accent)
                        .tag(nil as Project?)
                    ForEach(db.projects.sorted()) { project in
                        Text(project.unwrappedName)
                            .tag(project as Project?)
                    }
                } label: {
                    Text("Choose a Project")
                }
                .pickerStyle(.navigationLink)
                .font(.subheadline)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.accent, lineWidth: 1)
                }
            }

            VStack (alignment: .leading) {
                Text("Tags")
                    .fontWeight(.semibold)
                
                FlowLayout(mode: .scrollable, items: ["#Short", "#Items", "#Here", "#And", "#A"], itemSpacing: 4) {
                    Text($0)
                        .font(.subheadline)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColorInverted.opacity(0.5))
                        .foregroundColor(.accent)
                        .cornerRadius(20)
                }
                .padding(.horizontal, 4)
                .frame(maxWidth: .infinity, minHeight: 75)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.accent, lineWidth: 1)
                }
            }
            
            VStack (alignment: .leading) {
                Text("Description")
                    .fontWeight(.semibold)
                
                TextEditor(text: $description)
                    .foregroundStyle(.accent)
                    .font(.subheadline)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.accent, lineWidth: 1)
                    }
            }
        }
    }
}
