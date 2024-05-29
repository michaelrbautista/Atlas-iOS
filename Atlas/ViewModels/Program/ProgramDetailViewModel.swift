//
//  ProgramDetailViewModel.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProgramDetailViewModel: ObservableObject {
    
    // MARK: Variables
    var savedProgram: SavedProgram
    @Published var program: Program? = nil
    @Published var programIsLoading: Bool = true
    @Published var programIsSaving: Bool = false
    
    @Published var programIsSaved: Bool = false
    @Published var checkingIfUserSavedProgram: Bool = true
    
    @Published var programImage: UIImage? = nil
    @Published var programImageIsLoading = true
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(savedProgram: SavedProgram) {
        self.savedProgram = savedProgram
        
        DispatchQueue.main.async {
            self.programIsLoading = true
        }
        
        // Get program
        
        // Get image
        
        // Check if user has saved the program
        
    }
    
    // MARK: Get program
    public func getProgram(programId: String) {
        
    }
    
    // MARK: Delete program
    public func deleteProgram() {
        
    }
    
    // MARK: Unsave program
    public func unsaveProgram(programId: String) {
        self.programIsSaving = true
        
        
    }
    
    // MARK: Save program
    public func saveProgram(program: Program) {
        DispatchQueue.main.async {
            self.programIsSaving = true
        }
        
//        Task {
//            await WorkoutService.shared.saveProgram(program: program, username: savedProgram.username) { savedProgramRef, error in
//                if let error = error {
//                    self.didReturnError = true
//                    self.returnedErrorMessage = error.localizedDescription
//                    DispatchQueue.main.async {
//                        self.programIsSaving = false
//                    }
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    self.programIsSaved = true
//                    self.programIsSaving = false
//                }
//            }
//        }
    }
    
    // MARK: Check if user already saved program
    public func checkProgram(programId: String, uid: String, completion: @escaping (_ isSaved: Bool?, _ error: Error?) -> Void) {
        WorkoutService.shared.checkIfUserSavedProgram(programId: programId, uid: uid) { isSaved, error in
            if let error = error {
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
                completion(nil, error)
                return
            }
            
            completion(isSaved, nil)
        }
    }
    
    // MARK: Get program image
    public func getProgramImage(imageUrl: String, completion: @escaping (_ error: Error?) -> Void) {
        guard let fetchUrl = URL(string: imageUrl) else {
            print("Couldn't get url.")
            return
        }
        
        DispatchQueue.main.async {
            self.programImageIsLoading = true
        }
        
        let task = URLSession.shared.dataTask(with: fetchUrl) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.programImage = image
                }
            } else {
                print("Couldn't get image from data.")
                return
            }
        }
        
        task.resume()
    }
    
}
