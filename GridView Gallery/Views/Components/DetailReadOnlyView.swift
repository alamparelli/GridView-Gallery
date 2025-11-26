//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//
import SwiftUI

struct DetailReadOnlyView: View {
    let image: ImageItem
    
    @State private var description: String = ""
    
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
                
                TextEditor(text: $description)
                    .font(.subheadline)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .disabled(true)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.strokeBorder, lineWidth: 1)
                    }
                    .onAppear {
                        description = image.fulldescription ?? ""
                    }
//
//                Text(image.fulldescription ?? "")
//                        .font(.subheadline)
//                        .padding(.horizontal, 4)
//                        .frame(maxWidth: .infinity, minHeight: 75)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(.strokeBorder, lineWidth: 1)
//                        }
            }
        }
        .padding()
    }
}


//#Preview {
//    DetailReadOnlyView()
//}
