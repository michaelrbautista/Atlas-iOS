//
//  NutritionViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI
import HealthKit

final class NutritionViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    @Published var nutritionPlan: NutritionPlan? = nil
    @Published var basicActivity = 0
    @Published var totalCalories = 0
    
    @Published var returnedError = false
    @Published var errorMessage = ""
    
    init() {
        HKHealthStore.isHealthDataAvailable()
        
        if let data = UserDefaults.standard.object(forKey: "nutritionPlan") as? Data,
           let userNutritionPlan = try? JSONDecoder().decode(NutritionPlan.self, from: data) {
            nutritionPlan = userNutritionPlan
            
            self.basicActivity = Int(Double(userNutritionPlan.bmr) * 0.2)
            
            self.totalCalories = userNutritionPlan.bmr + self.basicActivity
        } else {
            print("No nutrition plan found.")
        }
    }
    
}
