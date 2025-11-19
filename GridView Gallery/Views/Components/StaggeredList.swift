//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct StaggeredList: View {
    let columns: Int = 2
    var images: [ImageItem] = []
    
    private var sortedImages: [ImageItem] {
        images.sorted(by: { $0.createdAt > $1.createdAt })
    }
    
    func splitArray() -> [[ImageItem]] {
        var result: [[ImageItem]] = []
        
        var list1: [ImageItem] = []
        var list2: [ImageItem] = []
        
        for (index, image) in sortedImages.enumerated() {
            if index % 2 == 0 {
                list1.append(image)
            } else {
                list2.append(image)
            }
        }
        
        result.append(list1)
        result.append(list2)
        return result
    }
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                LazyVStack(spacing: 8) {
                    ForEach(splitArray()[0]) { item in
                        ImageView(image: item)
                            .id(item.id)

                    }
                }
                
                LazyVStack(spacing: 8) {
                    ForEach(splitArray()[1]) { item in
                        ImageView(image: item)
                            .id(item.id)
                    }
                }
            }
            .padding()
        }
        .animation(.default, value: images.count)
        .scrollIndicators(.never)
    }
}

//#Preview {
//    StaggeredList()
//}
