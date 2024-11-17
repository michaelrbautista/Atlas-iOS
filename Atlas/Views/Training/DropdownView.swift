//
//  DropdownView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI

struct DropdownView: View {
    @Environment(\.dismiss) private var dismiss
    
    var options: [String]
    
    var onSelect: ((String) -> Void)
    
    var body: some View {
        List {
            ForEach(options, id: \.self) { option in
                Button {
                    onSelect(option)
                    dismiss()
                } label: {
                    Text(option)
                        .font(Font.FontStyles.body)
                        .foregroundStyle(Color.ColorSystem.primaryText)
                }
                .listRowBackground(Color.ColorSystem.systemGray6)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.ColorSystem.systemBackground)
    }
}

#Preview {
    DropdownView(options: ["Male", "Female"]) { option in
        
    }
}
