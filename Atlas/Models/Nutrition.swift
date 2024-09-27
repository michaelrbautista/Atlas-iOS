//
//  Nutrition.swift
//  Atlas
//
//  Created by Michael Bautista on 9/18/24.
//

import SwiftUI

struct NutritionPlan {
    var age: Int
    var sex: Sex
    var height: Int
    var weight: Int
    var goal: NutritionGoal
    var baseCalories: Int
}

enum Sex {
    case Male
    case Female
    case None
}

enum NutritionGoal {
    case LoseWeight
    case MaintainWeight
    case GainWeight
    case None
}
