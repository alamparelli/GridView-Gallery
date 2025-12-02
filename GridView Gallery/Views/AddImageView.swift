//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddImageView: View {
    @Environment(DatabaseService.self) var db
    
    @State var project: Project?
    @State private var image: ImageItem?
    
    @State private var description = ""
    @State private var selectedImageData: [Data] = []
    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var isLoading = false
    @State private var showCamera = false
    
    @State private var imageData: UIImage?
    
    @Environment(\.dismiss) var dismiss
    
    let colorsList: [Color] = [Color.red, Color.blue, Color.green, Color.yellow]
    @State private var offset = 10.0
    
    var disableSave: Bool {
        return isLoading && selectedImageData.isEmpty && imageData == nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Form {
                    VStack (alignment: .leading) {
                        HStack {
                            PhotosPicker(selection: $pickerItems, maxSelectionCount: 6, matching: .images , preferredItemEncoding: .compatible ) {
                                if selectedImageData.isEmpty {
                                    Label("Add a photo", systemImage: "photo.on.rectangle")
                                        .labelStyle(.iconOnly)
                                        .frame(width: 150, height: 100)
                                        .overlayModifierRounded()
                                        .contentShape(Rectangle())
                                } else {
                                    ZStack {
                                        ForEach(Array(selectedImageData.enumerated()), id: \.offset) { index, imageData in
                                            if let uiImage = UIImage(data: imageData)
//                                               let thumbnailData = uiImage.jpegData(compressionQuality: 0.6),
                                               /*let thumbnail = UIImage(data: uiImage)*/ {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 150, height: 100)
                                                    .clipped()
                                                    .clipShape(.rect(cornerRadius: 10))
//                                                    .offset(x: offset * Double(index) - 5)
    //                                                .rotationEffect(Angle(degrees: offset * Double(index) / 3 - 10))
                                            }
                                        }
                                        
                                        Text("\(selectedImageData.count)")
                                            .foregroundStyle(.accentColorInverted)
                                            .font(.largeTitle.bold())
                                    }
                                    .overlayModifierRounded()
                                    .contentShape(Rectangle())
                                }
                            }
                            .frame(width: 150, height: 100)
                            
                            Spacer()
                            
                            Button{
                                showCamera = true
                            } label: {
                                if let image = imageData {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 100)
                                        .clipped()
                                        .clipShape(.rect(cornerRadius: 10))
                                } else {
                                    Label("Take a picture", systemImage: "camera")
                                        .labelStyle(.iconOnly)
                                        .frame(width: 150, height: 100)
                                }
                            }

                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .overlayModifierRounded()
                    }
                    .padding([.top, .bottom])
                    
                    AddDetailsImageView(imageItem: $image, project: $project, description: $description)
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
                        .disabled(disableSave)
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
            
            image = ImageItem(imageData: Data(),fulldescription: "dummy")
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
        .fullScreenCover(isPresented: $showCamera) {
            ImagePickerView(image: $imageData)
                .ignoresSafeArea()
        }
    }
    
    func addImage() {
        // camera image
        if let imageData = imageData?.jpegData(compressionQuality: 1.0) {
//            image = ImageItem(imageData: imageData)
            image?.imageData = imageData
//            let img = ImageItem(imageData: imageData)
            
            if !description.isEmpty {
                image?.fulldescription = description
            }
            
            if let prj = project {
                image?.project = prj
            }
            
            db.addImageItem(image!)
        } else {
            for imageData in selectedImageData {
                let img = ImageItem(imageData: imageData)
                
                if !description.isEmpty {
                    img.fulldescription = description
                }
                
                if let prj = project {
                    img.project = prj
                }
                
                img.tags = image!.tags
                
                db.addImageItem(img)
            }
            
            db.removeImageItem(image!)
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
