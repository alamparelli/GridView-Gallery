//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

/// Settings view for configuring app preferences.
struct SettingsView: View {
    /// User's preferred theme setting stored persistently.
    @AppStorage("GridViewTheme") var theme = "Dynamic"

    /// Available theme options for user selection.
    let themeNames: [String] = ["Dynamic", "Light", "Dark"]
    
    var body: some View {
        VStack (alignment: .center){
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding([.horizontal, .top])
            List {
                Picker("Theme", selection: $theme) {
                    ForEach(themeNames, id: \.self) { pTheme in
                        Text(pTheme)
                    }
                }
            }.scrollContentBackground(.hidden)
        }
    }
}
