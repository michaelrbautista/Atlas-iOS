//
//  CreateNutritionPlanViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import Foundation
import SwiftUI

final class CreateNutritionPlanViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    @Published var age: String = ""
    @Published var sex: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var goal: String = "Maintain weight"
    
    @Published var returnedError = false
    @Published var errorMessage = ""
    
    public func createNutritionPlan() {
        if age == "" || sex == "" || height == "" || weight == "" || goal == "" {
            errorMessage = "Please fill in all fields."
            returnedError = true
            isLoading = false
            return
        }
        
        guard let ageNumber = Int(age) else {
            errorMessage = "Please enter a number for your age."
            returnedError = true
            isLoading = false
            return
        }
        
        guard let heightNumber = Int(height) else {
            errorMessage = "Please enter a number for your height."
            returnedError = true
            isLoading = false
            return
        }
        
        guard let weightNumber = Int(weight) else {
            errorMessage = "Please enter a number for your weight."
            returnedError = true
            isLoading = false
            return
        }
        
        let bmr = calculateBmr(
            age: ageNumber,
            weight: weightNumber,
            height: heightNumber
        )
        
        let userNutritionPlan = NutritionPlan(
            age: ageNumber,
            sex: sex,
            height: heightNumber,
            weight: weightNumber,
            goal: goal,
            bmr: bmr
        )
        
        if let encoded = try? JSONEncoder().encode(userNutritionPlan) {
            UserDefaults.standard.set(encoded, forKey: "nutritionPlan")
        } else {
            errorMessage = "Couldn't save nutrition plan."
            returnedError = true
            isLoading = false
            return
        }
    }
    
    public func calculateBmr(age: Int, weight: Int, height: Int) -> Int {
        let weightKilos = (Double(weight) * 0.453592)
        let heightCms = (Double(height) * 2.54)
        
        let section1 = (10 * weightKilos)
        let section2 = (6.25 * heightCms)
        let section3 = Double(5 * age)
        
        if sex == "Male" {
            return Int(section1 + section2 - section3 + Double(5))
        } else {
            return Int(section1 + section2 - section3 - Double(161))
        }
    }
}
