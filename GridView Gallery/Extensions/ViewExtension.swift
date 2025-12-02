//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// Custom view modifiers for consistent styling.
extension View {
    /// Applies inverted accent color theme.
    /// - Returns: View with inverted background and foreground colors.
    public func gridViewColorsInverted() -> some View {
        return self
            .background(.accentColorInverted)
            .foregroundStyle(.textInverted)
    }

    /// Applies standard accent color background.
    /// - Returns: View with accent background.
    public func gridViewColors() -> some View {
        return self
            .background(.accent)
    }
}
