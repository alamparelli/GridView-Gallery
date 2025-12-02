//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

/// Read-only view displaying image metadata.
struct DetailReadOnlyView: View {
    /// Image to display details for.
    @Binding var image: ImageItem?

    /// Local copy of description for display.
    @State private var description: String = ""
    
    var body: some View {
        Section {
            HStack {
                Text("Project")
                Spacer()
                Text(image?.project?.name ?? "None")
            }
            .pickerStyle(.navigationLink)
            .font(.subheadline)
            .padding()
            .overlayModifierRounded()

            TagsView(image: $image)
            
            VStack (alignment: .leading) {
                Text("Description")
                    .fontWeight(.semibold)
                
                TextEditor(text: $description)
                    .font(.subheadline)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .disabled(true)
                    .overlayModifierRounded()
                    .onAppear {
                        if let image = image {
                            description = image.fulldescription ?? ""
                        }
                    }
            }
        }
        .padding()
    }
}
