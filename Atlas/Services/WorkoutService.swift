//
//  WorkoutService.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import SwiftUI
import FirebaseFirestore

final class WorkoutService {
    
    public static let shared = WorkoutService()
    public static let db = Firestore.firestore()
    
    // MARK: Save program
    public func saveProgram(program: Program, completion: @escaping (_ savedProgramRef: SavedProgram?, _ error: Error?) -> Void) async {
        // Get username of user that created program
        await UserService.shared.getUser(uid: program.uid) { user, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let username = user?.username, let uid = user?.uid else {
                print("Couldn't get user.")
                return
            }
            
            guard let currentUser = UserService.currentUser else {
                print("Couldn't get current user")
                return
            }
            
            let savedProgramRef = WorkoutService.db.collection("savedPrograms").document()
            
            let savedProgram = SavedProgram(
                id: savedProgramRef.documentID,
                uid: currentUser.uid,
                creatorId: program.uid,
                programId: program.id,
                dateSaved: Date(),
                imageUrl: program.imageUrl,
                title: program.title,
                username: username
            )
            
            do {
                try savedProgramRef.setData(from: savedProgram) { error in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    completion(savedProgram, nil)
                    return
                }
            } catch let error {
                print("Error writing TrainingProgram to Firestore: \(error)")
                return
            }
        }
    }
    
    // MARK: Create program
    public func createProgram(createProgramRequest: CreateProgramRequest, completion: @escaping (_ savedProgramRef: SavedProgram?, _ error: Error?) -> Void) {
        // Get current user
        guard let currentUser = UserService.currentUser else {
            print("Couldn't get current user")
            return
        }
        
        // Create image path for TrainingProgram image
        let imagePath = "programImages/\(currentUser.uid)\(Date().hashValue).jpg"
        
        // 1. Save image
        StorageService.shared.saveImage(image: createProgramRequest.programImage ?? UIImage(), imagePath: imagePath) { url, error  in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let programRef = WorkoutService.db.collection("programs").document()
            
            let newProgram = Program(
                id: programRef.documentID,
                title: createProgramRequest.title,
                description: createProgramRequest.description,
                imageUrl: url?.absoluteString ?? "",
                imagePath: imagePath,
                uid: currentUser.uid,
                dateSaved: Date(),
                workouts: createProgramRequest.workouts
            )
            
            let savedProgramRef = WorkoutService.db.collection("savedPrograms").document()
            
            let savedProgram = SavedProgram(
                id: savedProgramRef.documentID,
                uid: currentUser.uid,
                creatorId: currentUser.uid,
                programId: programRef.documentID,
                dateSaved: Date(),
                imageUrl: newProgram.imageUrl,
                title: newProgram.title,
                username: currentUser.username
            )
            
            
            // 2. Save program
            do {
                try programRef.setData(from: newProgram) { error in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    // Add saveRef
                    do {
                        try savedProgramRef.setData(from: savedProgram) { error in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            completion(savedProgram, nil)
                            return
                        }
                    } catch let error {
                        print("Error writing program to Firestore: \(error)")
                        return
                    }
                }
            } catch let error {
                print("Error writing program to Firestore: \(error)")
                return
            }
        }
    }
    
    // MARK: Update program
    public func updateProgram(program: Program, completion: @escaping () -> Void) {
        
    }
    
    // MARK: Get program
    public func getProgram(programId: String, completion: @escaping (_ program: Program?, _ error: Error?) -> Void) {
        let programRef = WorkoutService.db.collection("programs").document(programId)
        
        programRef.getDocument(as: Program.self) { result in
            switch result {
            case .success(let program):
                completion(program, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    // MARK: Get user's saved programs
    public func getSavedPrograms(getProgramsRequest: GetProgramsRequest, completion: @escaping (_ newProgramRefs: [SavedProgram]?, _ lastProgramRef: QueryDocumentSnapshot?, _ error: Error?) -> Void) async {
        let programsRef = WorkoutService.db.collection("savedPrograms")
        
        var query: Query
        
        if getProgramsRequest.lastProgramRef != nil {
            query = programsRef
                .whereField("uid", isEqualTo: getProgramsRequest.uid)
                .order(by: "dateSaved", descending: true)
                .limit(to: 8)
                .start(afterDocument: getProgramsRequest.lastProgramRef!)
        } else {
            query = programsRef
                .whereField("uid", isEqualTo: getProgramsRequest.uid)
                .order(by: "dateSaved", descending: true)
                .limit(to: 8)
        }

        var newPrograms = [SavedProgram]()
        
        do {
            let querySnapshot = try await query.getDocuments()
            
            if querySnapshot.documents.count > 0 {
                for document in querySnapshot.documents {
                    do {
                        let savedProgram = try document.data(as: SavedProgram.self)
                        newPrograms.append(savedProgram)
                    } catch {
                        completion(nil, nil, error)
                        return
                    }
                }
                
                completion(newPrograms, querySnapshot.documents.last!, nil)
                return
            } else {
                completion(newPrograms, nil, nil)
                return
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    // MARK: Get creator's programs
    public func getCreatorPrograms(getProgramsRequest: GetProgramsRequest, completion: @escaping (_ newProgramRefs: [SavedProgram]?, _ lastProgramRef: QueryDocumentSnapshot?, _ error: Error?) -> Void) async {
        let programsRef = WorkoutService.db.collection("savedPrograms")
        
        var query: Query
        
        if getProgramsRequest.lastProgramRef != nil {
            query = programsRef
                .whereField("creatorId", isEqualTo: getProgramsRequest.uid)
                .whereField("uid", isEqualTo: getProgramsRequest.uid)
                .order(by: "dateSaved", descending: true)
                .limit(to: 8)
                .start(afterDocument: getProgramsRequest.lastProgramRef!)
        } else {
            query = programsRef
                .whereField("creatorId", isEqualTo: getProgramsRequest.uid)
                .whereField("uid", isEqualTo: getProgramsRequest.uid)
                .order(by: "dateSaved", descending: true)
                .limit(to: 8)
        }

        var newPrograms = [SavedProgram]()
        
        do {
            let querySnapshot = try await query.getDocuments()
            
            if querySnapshot.documents.count > 0 {
                for document in querySnapshot.documents {
                    do {
                        let savedProgram = try document.data(as: SavedProgram.self)
                        newPrograms.append(savedProgram)
                    } catch {
                        completion(nil, nil, error)
                        return
                    }
                }
                
                completion(newPrograms, querySnapshot.documents.last!, nil)
                return
            } else {
                completion(newPrograms, nil, nil)
                return
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    // MARK: Check if user saved program
    public func checkIfUserSavedProgram(programId: String, uid: String, completion: @escaping (_ isSaved: Bool, _ error: Error?) -> Void) {
        let programQuery = WorkoutService.db.collection("savedPrograms").whereField("uid", isEqualTo: uid).whereField("programId", isEqualTo: programId)
        
        programQuery.getDocuments { querySnapshot, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            if querySnapshot!.documents.count == 0 {
                completion(false, nil)
            } else {
                completion(true, nil)
                return
            }
        }
    }
    
    // MARK: Unsave program
    public func unsaveProgram(savedProgramId: String, completion: @escaping (_ error: Error?) -> Void) {
        guard let currentUser = UserService.currentUser else {
            print("Couldn't get current user")
            return
        }
        
        let unsaveProgramQuery = WorkoutService.db.collection("savedPrograms").whereField("programId", isEqualTo: savedProgramId).whereField("uid", isEqualTo: currentUser.uid)
        
        unsaveProgramQuery.getDocuments { querySnapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            let savedProgramRef = WorkoutService.db.collection("savedPrograms").document(querySnapshot!.documents[0].documentID)
            
            savedProgramRef.delete { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
                return
            }
        }
    }
    
    // MARK: Delete workout
    public func deleteProgram(program: Program, completion: @escaping (_ wasDeleted: Bool, _ error: Error?) -> Void) {
        // Delete references in savedTrainingPrograms
        let savedProgramRefs = WorkoutService.db.collection("savedPrograms").whereField("programId", isEqualTo: program.id)
        
        savedProgramRefs.getDocuments { snapshot, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(false, error)
                return
            }
            
            let batch = WorkoutService.db.batch()
            
            for document in snapshot.documents {
                let docRef = WorkoutService.db.collection("savedPrograms").document(document.documentID)
                batch.deleteDocument(docRef)
            }
            
            batch.commit { error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                // Delete TrainingProgram image
                StorageService.shared.deleteImage(imagePath: program.imagePath) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    // Delete TrainingProgram
                    WorkoutService.db.collection("programs").document(program.id).delete { error in
                        if let error = error {
                            completion(false, error)
                            return
                        }
                        
                        completion(true, nil)
                        return
                    }
                }
            }
        }
    }
}
