//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct AddImageView: View {
    @Environment(DatabaseService.self) var db
    
    @State var project: Project?
    @State private var tags: [Tag] = []
    @State private var description = ""
    @State private var selectedImages: [ImageItem] = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
            if !selectedImages.isEmpty {
            // Need to be rewritten to show all images in a stack of Photos and not one on the side of each Other
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 1) {
                        ForEach(selectedImages) { img in
                            if let uiImage = UIImage(data: img.thumbnailData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 600, maxHeight: 250)
                                    .clipped()
                            }
                        }
                    }
                    .frame(height: 250)
                }
                .scrollDisabled(selectedImages.count == 1)
                .scrollIndicators(.never)
                .scrollBounceBehavior(.basedOnSize)
                .padding(.bottom)
            }
            Form {
                if selectedImages.isEmpty {
                    VStack (alignment: .leading) {
                        HStack {
                            PhotoPickerView(selectedImages: $selectedImages)
                                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.accent, lineWidth: 1)
                                }
                                .contentShape(Rectangle())
                            
                            Button{
                                // Picture
                            } label: {
                                Image(systemName: "camera")
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.accent, lineWidth: 1)
                                    }
                            }
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.accent, lineWidth: 1)
                        }
                    }
                    .padding(.top, 100)
                    .padding(.bottom)
                }
                
                AddDetailsImageView(project: $project, tags: $tags, description: $description)
            }
            .padding(.horizontal)
            .navigationTitle("Add Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.accent)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        addImage()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundStyle(.accent)
                    }
                    .tint(.accentColorInverted)
                    .buttonStyle(.borderedProminent)
                }
            }
            .formStyle(.columns)
            }
            .scrollIndicators(.never)
            .ignoresSafeArea(edges: .top)
        }
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
    
    func addImage() {
        for img in selectedImages {
            if !description.isEmpty {
                img.fulldescription = description
            }
            
            if !tags.isEmpty {
                img.tags = tags
            }
            
            if let prj = project {
                img.project = prj
            }
            
            db.addImageItem(img)
        }
        
        dismiss()
    }
}

//#Preview {
//    AddImageView()
//}
