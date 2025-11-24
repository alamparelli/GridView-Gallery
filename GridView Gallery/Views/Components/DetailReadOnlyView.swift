//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

struct DetailReadOnlyView: View {
    let image: ImageItem
    
    var body: some View {
        Section {
            HStack {
                Text("Project")
                Spacer()
                Text(image.project?.name ?? "None")
            }
            .pickerStyle(.navigationLink)
            .font(.subheadline)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.strokeBorder, lineWidth: 1)
            }

            TagsView(image: image)
            
            VStack (alignment: .leading) {
                Text("Description")
                    .fontWeight(.semibold)
                
                Text(image.fulldescription ?? "")
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.strokeBorder, lineWidth: 1)
                    }
            }
        }
        .padding()
    }
}
