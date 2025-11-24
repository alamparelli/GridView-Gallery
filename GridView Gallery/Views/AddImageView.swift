//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddImageView: View {
    @Environment(DatabaseService.self) var db
    
    @State var project: Project?
    @State private var tags: [Tag] = []
    @State private var description = ""
    @State private var selectedImageData: [Data] = []
    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var isLoading = false
    
    @Environment(\.dismiss) var dismiss
    
    let colorsList: [Color] = [Color.red, Color.blue, Color.green, Color.yellow]
    @State private var offset = 10.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Form {
                    if selectedImageData.isEmpty {
                        VStack (alignment: .leading) {
                            HStack {
                                PhotosPicker(selection: $pickerItems, maxSelectionCount: 6, matching: .images , preferredItemEncoding: .compatible ) {
                                    Label("Add a photo", systemImage: "photo.on.rectangle")
                                        .labelStyle(.iconOnly)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .contentShape(Rectangle())
                                }
                                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.strokeBorder, lineWidth: 1)
                                }
                                .contentShape(Rectangle())
                                
                                Button{
                                    // Picture
                                } label: {
                                    Label("Take a picture", systemImage: "camera")
                                        .labelStyle(.iconOnly)
                                        .frame(maxWidth: .infinity, minHeight: 100)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.strokeBorder, lineWidth: 1)
                                        }
                                }
                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.strokeBorder, lineWidth: 1)
                            }
                        }
                        .padding([.top, .bottom])
                    } else {
                        HStack {
                            Spacer()
                            
                            PhotosPicker(selection: $pickerItems, maxSelectionCount: 6, matching: .images , preferredItemEncoding: .compatible ) {
                                ZStack {
                                    ForEach(Array(selectedImageData.enumerated()), id: \.offset) { index, imageData in
                                        if let uiImage = UIImage(data: imageData),
                                           let thumbnailData = uiImage.jpegData(compressionQuality: 0.8),
                                           let thumbnail = UIImage(data: thumbnailData) {
                                            Image(uiImage: thumbnail)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 100)
                                                .clipped()
                                                .clipShape(.rect(cornerRadius: 10))
                                                .offset(x: offset * Double(index) - 5)
//                                                .rotationEffect(Angle(degrees: offset * Double(index) / 3 - 10))
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom)
                        
                    }
                    
                    AddDetailsImageView(imageItem: nil, tags: $tags, project: $project, description: $description)
                }
                .padding(.horizontal)
                .navigationTitle("Add Image")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button{
                            dismiss()
                        } label: {
                            Label("Cancel", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.accent)
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button{
                            addImage()
                        } label: {
                            Label("Add Image", systemImage:  "square.and.arrow.down")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.accent)
                        }
                        .disabled(isLoading)
                        .tint(.accentColorInverted)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .formStyle(.columns)
            }
            .scrollIndicators(.never)
        }
        .onChange(of: pickerItems) {
            Task {
                isLoading = true
                selectedImageData = []
                for item in pickerItems {
                    if let data = try await item.loadTransferable(type: Data.self) {
                        // Convert data to UIImage first
                        if let uiImage = UIImage(data: data) {
                            if let imageDisk = uiImage.jpegData(compressionQuality: 0.5) {
                                selectedImageData.append(imageDisk)
                            }
                        }
                    }
                }
                isLoading = false
            }
        }
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
    
    func addImage() {
        for imageData in selectedImageData {
            let img = ImageItem(imageData: imageData)
            
            if !description.isEmpty {
                img.fulldescription = description
            }
            
            // Use the @State tags directly (populated by TagsView via binding)
            img.tags = tags
            
            if let prj = project {
                img.project = prj
            }
            
            db.addImageItem(img)
        }
        
        pickerItems = []
        dismiss()
    }
}

#Preview {
    let modelContainer: ModelContainer
    let schema = Schema([ImageItem.self])
    
    do {
        modelContainer = try ModelContainer(for: schema)
        
        return AddImageView()
            .environment(DatabaseService(context: modelContainer.mainContext))
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
