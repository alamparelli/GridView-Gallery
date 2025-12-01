//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI
import SwiftData

struct DebugView: View {
    @Query var images: [ImageItem]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Button("Delete all images") {
            for image in images {
                modelContext.delete(image)
            }
            try? modelContext.save()
        }
    }
}

//#Preview {
//    DebugView()
//}
