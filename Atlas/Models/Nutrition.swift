//
//  Nutrition.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI

struct NutritionPlan: Codable {
    var age: Int
    var sex: String
    var height: Int
    var weight: Int
    var goal: String
    var bmr: Int
}
