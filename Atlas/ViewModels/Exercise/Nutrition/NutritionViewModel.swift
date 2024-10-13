//
//  NutritionViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI

final class NutritionViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    @Published var nutritionPlan: NutritionPlan? = nil
    
    @Published var returnedError = false
    @Published var errorMessage = ""
    
    init() {
        if let data = UserDefaults.standard.object(forKey: "nutritionPlan") as? Data,
           let userNutritionPlan = try? JSONDecoder().decode(NutritionPlan.self, from: data) {
            nutritionPlan = userNutritionPlan
        } else {
            print("No nutrition plan found.")
        }
    }
    
}
