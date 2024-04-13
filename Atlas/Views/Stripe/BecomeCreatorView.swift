//
//  BecomeCreatorView.swift
//  Atlas
//
//  Created by Michael Bautista on 4/11/24.
//

import SwiftUI

struct BecomeCreatorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Become a creator")
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "multiply") {
                        dismiss()
                    }
                }
            })
        }
    }
}

#Preview {
    BecomeCreatorView()
}
