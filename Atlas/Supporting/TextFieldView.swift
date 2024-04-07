//
//  TextFieldView.swift
//  stayhard
//
//  Created by Michael Bautista on 3/21/24.
//

import SwiftUI

struct TextFieldView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var textEntered: String
    
    var body: some View {
        List {
            Section {
                TextField("", text: $textEntered, prompt: textEntered == "" ? Text("Add description...") : Text(""), axis: .vertical)
                    .lineLimit(16...)
                    .listRowBackground(Color.ColorSystem.systemGray4)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.ColorSystem.systemGray5)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    dismiss()
                }
                .tint(Color.ColorSystem.systemBlue)
            }
        })
    }
}

#Preview {
    TextFieldView(textEntered: .constant("Test"))
}
