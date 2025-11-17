//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct AddImageView: View {
    @Environment(DatabaseService.self) var db
    @State private var project: Project?
    @State private var tags: [Tag] = []
    @State private var description = ""
    @State private var selectedImages: [ImageItem] = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
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
                } else {
                    // Need to be rewritten to show all images in a stack of Photos and not one on the side of each Other
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            if let uiImg = image.uiImage, let thumbnail = uiImg.preparingThumbnail(of: CGSize(width: uiImg.size.width / 4, height: uiImg.size.height / 4 )) {
                                Image(uiImage: thumbnail)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                        }
                    }
                    .ignoresSafeArea(edges: .top)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(.accent, lineWidth: 1)
//                    }
                }

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
                    .font(.subheadline)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.accent, lineWidth: 1)
                    }
                }
            }
            .padding()
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
