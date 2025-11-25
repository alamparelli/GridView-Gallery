//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct DebugView: View {
    var image: ImageItem
    @State var fullScreen = false
    
    var body: some View {
        GeometryReader { geo in
            if let uiImage = UIImage(data: image.thumbnailData) {
                let collapsedHeight: CGFloat = 250
                let collapsedWidth: CGFloat = min(600, geo.size.width)
                
                VStack(spacing: 0) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: fullScreen ? .fit : .fill)
                        .frame(
                            width: fullScreen ? geo.size.width : collapsedWidth,
                            height: fullScreen ? geo.size.height : collapsedHeight
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                fullScreen.toggle()
                            }
                        }
                    
                    if !fullScreen {
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
                .ignoresSafeArea(edges: fullScreen ? .all : [])
            }
        }
    }
}

//#Preview {
//    DebugView()
//}
