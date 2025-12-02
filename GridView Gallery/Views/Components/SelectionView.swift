//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// Visual indicator showing selection state in edit mode.
struct SelectionView: View {
    /// Whether the item is currently selected.
    let isSelected: Bool
    
    var body: some View {
        Circle()
            .fill(isSelected ? Color.accent : Color.white.opacity(0.3))
            .stroke(.white, lineWidth: 2 )
            .frame(width: 20, height: 20)
    }
}

#Preview {
    SelectionView(isSelected: false)
}
