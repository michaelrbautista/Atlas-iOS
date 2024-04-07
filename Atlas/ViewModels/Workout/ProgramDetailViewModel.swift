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
    @Published var program: Program? = nil
    @Published var programIsLoading: Bool = true
    @Published var programIsSaving: Bool = false
    
    @Published var programIsSaved: Bool = false
    @Published var checkingIfUserSavedProgram: Bool = true
    
    @Published var programImage: UIImage? = nil
    @Published var programImageIsLoading = true
    
    @Published var currentUser: User? = nil
    @Published var user: User? = nil
    
    @Published var didReturnError = false
    @Published var returnedErrorMessage = ""
    
    // MARK: Initializer
    init(programId: String) {
        DispatchQueue.main.async {
            self.programIsLoading = true
        }
        
        getProgram(programId: programId) { program, user, error in
            DispatchQueue.main.async {
                self.programIsLoading = false
            }
            
            if let error = error {
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
                return
            }
            
            DispatchQueue.main.async {
                self.program = program
                self.user = user
            }
            
            guard let currentUser = UserService.currentUser else {
                print("Couldn't get current user")
                return
            }
            
            DispatchQueue.main.async {
                self.currentUser = currentUser
            }
            
            self.checkProgram(programId: program!.id, uid: currentUser.uid) { isSaved, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.checkingIfUserSavedProgram = false
                        self.didReturnError = true
                        self.returnedErrorMessage = error.localizedDescription
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.programIsSaved = isSaved!
                    self.checkingIfUserSavedProgram = false
                }
            }
            
            self.getProgramImage(imageUrl: program?.imageUrl ?? "") { error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.didReturnError = true
                        self.returnedErrorMessage = error.localizedDescription
                    }
                    return
                }
            }
        }
    }
    
    // MARK: Get program
    public func getProgram(programId: String, completion: @escaping (_ program: Program?, _ user: User?, _ error: Error?) -> Void) {
        WorkoutService.shared.getProgram(programId: programId) { program, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            if let program = program {
                Task {
                    await UserService.shared.getUser(uid: program.uid) { user, error in
                        if let error = error {
                            completion(nil, nil, error)
                            return
                        }
                        
                        completion(program, user, nil)
                    }
                }
            }
        }
    }
    
    // MARK: Delete program
    public func deleteProgram() {
        WorkoutService.shared.deleteProgram(program: program!) { wasDeleted, error in
            self.programIsSaving = true
            
            if let error = error {
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
                return
            }
        }
    }
    
    // MARK: Unsave program
    public func unsaveProgram(programId: String) {
        self.programIsSaving = true
        
        WorkoutService.shared.unsaveProgram(savedProgramId: programId) { error in
            if let error = error {
                self.didReturnError = true
                self.returnedErrorMessage = error.localizedDescription
                DispatchQueue.main.async {
                    self.programIsSaving = false
                }
                return
            }
            
            DispatchQueue.main.async {
                self.programIsSaved = false
                self.programIsSaving = false
            }
        }
    }
    
    // MARK: Save program
    public func saveProgram(program: Program) {
        DispatchQueue.main.async {
            self.programIsSaving = true
        }
        
        Task {
            await WorkoutService.shared.saveProgram(program: program) { savedProgramRef, error in
                if let error = error {
                    self.didReturnError = true
                    self.returnedErrorMessage = error.localizedDescription
                    DispatchQueue.main.async {
                        self.programIsSaving = false
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.programIsSaved = true
                    self.programIsSaving = false
                }
            }
        }
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
    
    // MARK: Get team image
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
