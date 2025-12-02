//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct TagsView: View {
    // Support BOTH patterns
    @Binding var image: ImageItem?
    
    @State private var isEditing = false
    var showEditDetails = false
    
    @Environment(DatabaseService.self) var db
    
    @FocusState private var isFocused: Bool
    @State private var tagString: String = ""
    
    // tag proposal
    @State private var currentWord: String = ""
    
    private var tagSuggestions: [Tag] {
        guard !currentWord.isEmpty else { return [] }
        guard let image = image else { return [] }
        
        let existingNames = Set(image.tags.map { $0.name.lowercased() })
        
        return db.getTags()
            .filter { tag in
                tag.name.lowercased().localizedStandardContains(currentWord)
                && !existingNames.contains(tag.name.lowercased())
            }
            .prefix(5)  // Limite à 5 suggestions
            .map { $0 }
    }
    
    private var filteredTags: [String] {
//        guard let image = image else { return [] }
        
        return tagString.split(separator: " ").map(String.init)
        
//        return image.tags.filter { tag in
//            tmpArray.contains(tag.name)
//        }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Tags")
                .fontWeight(.semibold)
            
            VStack {
                if !isEditing {
                    FlowLayout(mode: .scrollable, items: filteredTags/*.sorted(by: { $0.name < $1.name })*/, itemSpacing: 4) { tag in
                            ZStack (alignment: .trailing) {
                                Text("#\(tag)")
                                    .font(.subheadline)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .padding(.trailing, showEditDetails ? 16 : 8)
                                    .background(Color.accentColorInverted.opacity(0.5))
                                    .cornerRadius(20)
                                
                                if showEditDetails {
                                    Button {
                                        removeTagFromSelection(tag)
                                    } label: {
                                        Label("Remove tag", systemImage: "x.circle.fill")
                                            .labelStyle(.iconOnly)
                                            .foregroundStyle(.secondary)
                                            .font(.subheadline)
                                            .padding(.trailing, 4)
                                    }
                                }
                            }
                        }
                } else {
                    TextEditor(text: $tagString)
                        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 200)
                        .padding(4)
                        .focused($isFocused)
//                    https://stackoverflow.com/questions/70318811/detecting-keyboard-submit-button-press-for-texteditor-swiftui
                        .onChange(of: tagString) {                            
                            // Handle return key
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
                            .padding(.horizontal)
                            .clipShape(.circle)
                        }
                }
            }
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity, minHeight: 100)
            .overlayModifierRounded()
            
            if isEditing && !tagSuggestions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tagSuggestions.sorted(by: { $0.name > $1.name })) { tag in
                            Button {
                                appendTag(tag.name)
                            } label: {
                                Text("#\(tag.name)")
                                    .font(.subheadline)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColorInverted.opacity(0.5))
                                    .cornerRadius(20)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .gesture(showEditDetails ? TapGesture().onEnded {
            self.isEditing = true
            self.isFocused.toggle()
        } : nil)
        .onAppear(perform: showTags)
        .onChange(of: image?.tags) { showTags() }
        .onChange(of: tagString) { oldValue, newValue in
            if newValue.hasSuffix(" ") {
                currentWord = ""
                convertTags()
            } else {
                currentWord = newValue.split(separator: " ").last.map(String.init) ?? ""
            }
        }
        .animation(.default, value: tagSuggestions)
        .animation(.none, value: tagString)
    }
  
        func removeTagFromSelection(_ tag: String) {
//    func removeTagFromSelection(_ tag: Tag) {
        let name = tag
        
        let tempArray: [String] = tagString.lowercased()
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .filter { $0 != name }
        
        tagString = tempArray.joined(separator: " ") + " "
        
        convertTags()
    }
    
    func appendTag(_ tagName: String) {
        var words = tagString.split(separator: " ").map(String.init)
        if !words.isEmpty {
            words.removeLast()
        }
        words.append(tagName)
        tagString = words.joined(separator: " ") + " "
        convertTags()
    }
    
    func showTags() {
        if let tags = image?.tags {
            tagString = tags.map({ $0.name }).joined(separator: " ")
        }
    }

    func convertTags() {
        // Parse new tags
        let tagNames = Set(
            tagString.lowercased()
                .split(separator: " ")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        )
        
        image?.tags = tagNames.map { db.checkTag(String($0)) }
    }
}
