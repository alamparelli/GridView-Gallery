//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct TagsView: View {
    // Support BOTH patterns
    private var image: ImageItem?
    @Binding private var tagsBinding: [Tag]?
    private let useBinding: Bool
    
    @State private var isEditing = false
    var showEditDetails = false
    
    @Environment(DatabaseService.self) var db
    @FocusState private var isFocused: Bool
    @State private var tagString: String = ""
    
    // INIT 1: For editing existing images (ImageDetailView)
    init(image: ImageItem, showEditDetails: Bool = false) {
        self.image = image
        self._tagsBinding = .constant(nil)
        self.useBinding = false
        self.showEditDetails = showEditDetails
    }
    
    // INIT 2: For creating new images (AddImageView)
    init(tags: Binding<[Tag]>, showEditDetails: Bool = false) {
        self.image = nil
        self._tagsBinding = Binding(
            get: { tags.wrappedValue },
            set: { tags.wrappedValue = $0 ?? [] }
        )
        self.useBinding = true
        self.showEditDetails = showEditDetails
    }
    
    private var tags: [Tag] {
        if useBinding {
            return tagsBinding ?? []
        } else {
            return image?.tags ?? []
        }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Tags")
                .fontWeight(.semibold)
            
            VStack {
                if !isEditing {
                    FlowLayout(mode: .scrollable, items: tags.sorted(by: { $0.name < $1.name }), itemSpacing: 4) {
                        Text("#\($0.name)")
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColorInverted.opacity(0.5))
                            .cornerRadius(20)
                    }
                } else {
                    TextEditor(text: $tagString)
                        .padding(.horizontal, 4)
                        .padding(.vertical)
                        .focused($isFocused)
//                    https://stackoverflow.com/questions/70318811/detecting-keyboard-submit-button-press-for-texteditor-swiftui
                        .onChange(of: tagString) {
                            if !tagString.filter({ $0.isNewline }).isEmpty {
                                convertTags()
                                self.isFocused = false
                                self.isEditing = false
                            }
                        }
                        .safeAreaBar(edge: .trailing) {
                            Button {
                                convertTags()
                                self.isFocused = false
                                self.isEditing = false
                            } label: {
                                Label("Submit tags", systemImage: "checkmark")
                                    .labelStyle(.iconOnly)
                            }
                            .padding()
                            .clipShape(.circle)
                        }
                }
            }
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity, minHeight: 75)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.strokeBorder, lineWidth: 1)
            }
        }
        .contentShape(Rectangle())
        .gesture(showEditDetails ? TapGesture().onEnded {
            self.isEditing = true
            self.isFocused.toggle()
        } : nil)
        .onAppear(perform: showTags)
        .onChange(of: tags) { showTags() }
    }
    
    func showTags() {
        tagString = tags.map({ $0.name }).joined(separator: ",")
    }

    func convertTags() {
        // Parse new tags
        let tagNames = Set(
            tagString.lowercased()
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        )
        
        // Get/create Tag objects
        let newTags = tagNames.map { db.checkTag(String($0)) }
        
        // Update based on pattern
        if useBinding {
            // Pattern A: Update binding for AddImageView
            tagsBinding = newTags
        } else {
            // Pattern B: Update model directly for ImageDetailView
            if image?.tags == nil {
                image?.tags = []
            }
            image?.tags = newTags
        }
    }
}
