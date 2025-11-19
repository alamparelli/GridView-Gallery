//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

struct ImageDetailView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    @Environment(\.dismiss) var dismiss
    
    var image: ImageItem?
    var images: [ImageItem]

    @State private var selectedImageID: PersistentIdentifier?
    @State private var selectedImage: ImageItem?
    @State private var showEditDetails = false
    
    // Edit mode
    @State private var project: Project?
    @State private var tags: [Tag] = []
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedImageID) {
                    ForEach(images.sorted(by: { $0.createdAt > $1.createdAt }) ) { img in
                        ScrollView {
                            VStack(spacing: 0) {
                                if let uiImage = UIImage(data: img.thumbnailData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 600, maxHeight: 250)
                                        .clipped()
                                }
                                
                                if showEditDetails {
                                    AddDetailsImageView(project: $project, tags: $tags, description: $description)
                                        .padding()
                                } else {
                                    DetailReadOnlyView(img: img)
                                }
                            }
                        }
                        .scrollIndicators(.never)
                        .tag(img.persistentModelID)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: showEditDetails ? .never : .automatic))
                .ignoresSafeArea(edges: .top)
                //            .disabled(showEditDetails)
                .highPriorityGesture(
                    showEditDetails ? DragGesture() : nil
                )
                .animation(.easeInOut, value: showEditDetails)
                
                VStack {
                    HStack {
                        Button {
                            showEditDetails ? showEditDetails = false : dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.accent)
                                .padding(12)
                                .glassEffect()
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Button {
                            doWork()
                        } label: {
                            Image(systemName: showEditDetails ? "square.and.arrow.down" : "pencil")
                                .foregroundStyle(.accent)
                                .padding(12)
                                .background(.accentColorInverted)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .onChange(of: image) {
                selectedImage = image
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
                
                // Set the initial selected image
                if let image = image {
                    selectedImageID = image.persistentModelID
                    selectedImage = image
                }
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
            //            .toolbar {
            //                ToolbarItem(placement: .cancellationAction) {
            //                    Button{
            //                        dismiss()
            //                    } label: {
            //                        Image(systemName: "xmark")
            //                            .foregroundStyle(.accent)
            //                    }
            //                }
            //                ToolbarItem(placement: .confirmationAction) {
            //                    Button{
            //                        showEditDetails = true
            //                    } label: {
            //                        Image(systemName: "pencil")
            //                            .foregroundStyle(.accent)
            //                    }
            //                    .tint(.accentColorInverted)
            //                    .buttonStyle(.borderedProminent)
            //                }
            //            }
        }
    }
    
    func doWork() {
        if showEditDetails {
            showEditDetails = false
            
            selectedImage!.fulldescription = description
            selectedImage!.project = project
            selectedImage!.tags = tags
            
            db.editImageItem()
        } else {
            description = selectedImage?.fulldescription ?? "ddd"
            tags = selectedImage?.tags ?? []
            project = selectedImage?.project
            
            showEditDetails = true
        }
    }
}
//#Preview {
//    DebugView()
//}
