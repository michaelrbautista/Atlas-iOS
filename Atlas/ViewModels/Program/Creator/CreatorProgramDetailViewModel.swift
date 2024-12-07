//
//  CreatorProgramDetailViewModel.swift
//  Atlas
//
//  Created by Michael Bautista on 12/6/24.
//

import SwiftUI

final class CreatorProgramDetailViewModel: ObservableObject {
    
    @Published var isLoading = true
    
    var programId: String
    var program: Program? = nil
    
    @Published var programImage: UIImage? = nil
    @Published var programImageIsLoading = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(programId: String) {
        self.programId = programId
        
        Task {
            await getProgram()
        }
    }
    
    // MARK: Get program
    @MainActor
    public func getProgram() async {
        Task {
            do {
                // Get program
                let program = try await ProgramService.shared.getProgram(programId: programId)
                
                self.program = program
                self.isLoading = false
                
                // Get image
                if let imageUrl = program.imageUrl {
                    try await self.getProgramImage(imageUrl: imageUrl)
                } else {
                    self.programImageIsLoading = false
                    self.programImage = UIImage(systemName: "figure.run")
                }
            } catch {
                self.isLoading = false
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: Get program image
    @MainActor
    public func getProgramImage(imageUrl: String) async throws {
        self.programImageIsLoading = true
        
        guard let imageUrl = URL(string: imageUrl) else {
            self.programImageIsLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            self.programImageIsLoading = false
            self.programImage = image
        } catch {
            throw error
        }
    }
    
}

