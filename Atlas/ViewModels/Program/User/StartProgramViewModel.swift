//
//  StartProgramViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 9/30/24.
//

import SwiftUI

final class StartProgramViewModel: ObservableObject {
    
    public func startProgram(programId: String, startDate: (Int, String)) {
        let days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
        
        guard let dayNumber = days.firstIndex(of: startDate.1) else {
            print("Couldn't get number of days.")
            return
        }
        
        // Convert start date to number, then figure out how many days it's been since then
        let startDayAsNumber = ((startDate.0 - 1) * 7) + dayNumber
        
        UserDefaults.standard.set(programId, forKey: "startedProgram")
        UserDefaults.standard.set(startDayAsNumber, forKey: "startDayAsNumber")
        UserDefaults.standard.set(Date.now, forKey: "startDate")
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
    }
    
}
