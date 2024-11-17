//
//  NutritionView.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI

struct NutritionView: View {
    
    // MARK: UI State
    @State var presentSettings = false
    @State var presentCreateNutritionPlan = false
    @State var presentAddExercise = false
    
    // MARK: View Model
    @StateObject var viewModel = NutritionViewModel()
    
    var body: some View {
        Text("Nutrition")
    }
}

#Preview {
    NutritionView()
        .environmentObject(UserViewModel())
}
