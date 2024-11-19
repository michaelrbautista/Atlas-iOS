//
//  HealthKitService.swift
//  Atlas
//
//  Created by Michael Bautista on 11/9/24.
//

import SwiftUI
import HealthKit

final class HealthKitService: ObservableObject {
    
    public static let healthStore = HKHealthStore()
    
    init() {
        print(HKHealthStore.isHealthDataAvailable())
    }
    
}
