//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct ImageDetailView: View {
    var image: ImageItem
    
    var body: some View {
        ScrollView {
            if let uiImage = UIImage(data: image.imageData),
               let thumbnail = uiImage.preparingThumbnail(of: CGSize(width: uiImage.size.width / 2, height: uiImage.size.height / 2)) {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 400)
                    .clipped()
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
}

//#Preview {
//    ImageDetailView()
//}
