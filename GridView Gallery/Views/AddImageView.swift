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
    @State private var selectedImages: [ImageItem] = []
    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var isLoadingImages: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    let colorsList: [Color] = [Color.red, Color.blue, Color.green, Color.yellow]
    @State private var offset = 10.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Form {
                    if selectedImages.isEmpty {
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
                                    Image(systemName: "camera")
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
                                    ForEach(selectedImages.enumerated(), id: \.element) { element, img in
                                        if let uiImage = UIImage(data: img.thumbnailData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 100)
                                                .clipped()
                                                .clipShape(.rect(cornerRadius: 10))
                                                .offset(x: offset * Double(element) - 10)
//                                                .rotationEffect(Angle(degrees: offset * Double(element) / 3 - 10))
                                        }
                                    }
                                }
                                .redacted(reason: isLoadingImages ? .placeholder : [])
                            }
                            
                            Spacer()
                        }
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
        }
        .onChange(of: pickerItems) {
            Task {
                isLoadingImages = true
                selectedImages = []
                for item in pickerItems {
                    if let data = try await item.loadTransferable(type: Data.self) {
                        // Convert data to UIImage first
                        if let uiImage = UIImage(data: data) {
                            if let imageDisk = uiImage.jpegData(compressionQuality: 0.5) {
                                let image = ImageItem(imageData: imageDisk)
                                selectedImages.append(image)
                            }
                        }
                    }
                }
                isLoadingImages = false
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
