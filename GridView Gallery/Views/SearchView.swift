//
// Copyright (c) 2025. Created by Alessandro L. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    var body: some View {
        Text("SearchView")
            .searchable(text: $searchText)
    }
}

#Preview {
    SearchView()
}
