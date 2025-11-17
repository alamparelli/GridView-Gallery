//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

struct DebugView: View {
    @Environment(NavigationService.self) var ns
    @Environment(DatabaseService.self) var db
    var image: ImageItem?
    var images: [ImageItem]
    
    @State private var project: Project?
    @State private var tags: [Tag] = []
    @State private var description = ""

    @State private var selectedImageID: PersistentIdentifier?
    
    var body: some View {
        TabView(selection: $selectedImageID) {
            ForEach(images) { image in
                ScrollView {
                    if let uiImage = UIImage(data: image.imageData) {
                        if let thumbnail = uiImage.preparingThumbnail(of: CGSize(width: uiImage.size.width / 2, height: uiImage.size.height / 2)) {
                            Image(uiImage: thumbnail)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 400, maxHeight: 700)
                                .clipped()
                        }
                    }
                    
                    Section {
                        Text("Liste")

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

                }
                .scrollIndicators(.never)
                .tag(image.persistentModelID)  // Add tag to each page
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            UIScrollView.appearance().bounces = false
            // Set the initial selected image
            if let image = image {
                selectedImageID = image.persistentModelID
            }
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
}
//#Preview {
//    DebugView()
//}
