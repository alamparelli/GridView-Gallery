//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

extension View {
    public func gridViewColorsInverted() -> some View {
        return self
            .background(.accentColorInverted)
            .foregroundStyle(.textInverted)
    }
    
    public func gridViewColors() -> some View {
        return self
            .background(.accent)
    }
}
