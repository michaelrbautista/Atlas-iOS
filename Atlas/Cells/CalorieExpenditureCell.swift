//
//  CalorieExpenditureCell.swift
//  Atlas
//
//  Created by Michael Bautista on 11/8/24.
//

import SwiftUI

struct CalorieExpenditureCell: View {
    
    var activity: String
    var calories: Int
    
    var body: some View {
        HStack(spacing: 10) {
            Text(activity)
                .font(Font.FontStyles.headline)
                .foregroundStyle(Color.ColorSystem.primaryText)
            
            Spacer()
            
            Text("\(calories) cal")
                .font(Font.FontStyles.headline)
                .foregroundStyle(Color.ColorSystem.systemGray)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color.ColorSystem.systemGray6)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CalorieExpenditureCell(activity: "Test", calories: 12)
}
