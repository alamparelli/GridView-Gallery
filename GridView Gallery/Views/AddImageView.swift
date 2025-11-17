//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct AddImageView: View {
    @Environment(DatabaseService.self) var db
    @State private var project = ""
    @State private var tags: [Tag] = []
    @State private var description = ""
    @State private var selectedImages: [ImageItem] = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack (alignment: .leading) {
                    HStack {
                        if selectedImages.isEmpty {
                            PhotoPickerView(selectedImages: $selectedImages)
                                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.accent, lineWidth: 1)
                                }
                                .contentShape(Rectangle())

                        } else {
                            // Need to be rewritten to show all images in a stack of Photos and not one on the side of each Other
                            ForEach(selectedImages, id: \.self) { image in
                                if let uiImg = image.uiImage, let thumbnail = uiImg.preparingThumbnail(of: uiImg.size) {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 1)
                            }
                        }
                        Image(systemName: "camera")
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 1)
                            }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.accent, lineWidth: 1)
                    }
                }
                
                Picker("Select Project", selection: $project) {
                    ForEach(db.projects) { project in
                        Text(project.unwrappedName)
                    }
                }
                .pickerStyle(.navigationLink)
                .font(.subheadline)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.accent, lineWidth: 1)
                }
                
                VStack (alignment: .leading) {
                    Text("Tags")
                        .fontWeight(.semibold)
                    
                    FlowLayout(mode: .scrollable, items: ["Short", "Items", "Here", "And", "A", "Few", "More",
                                                          "And then a very very very long one"], itemSpacing: 4) {
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
                        db.addProject(Project(name: project))
                        dismiss()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundStyle(.accent)
                    }
                    .tint(.accentColorInverted)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

//#Preview {
//    AddImageView()
//}
