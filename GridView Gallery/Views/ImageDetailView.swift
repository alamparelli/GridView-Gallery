//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ImageDetailView: View {
    var image: ImageItem
    
    var body: some View {
        ScrollView {
            if let thumbnailData = image.thumbnailData, let uiImage = UIImage(data: thumbnailData){
                Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
//                        .clipped()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

//#Preview {
//    ImageDetailView()
//}
