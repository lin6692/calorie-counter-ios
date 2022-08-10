//
//  UserDataManager.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/9/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import GoogleSignIn

class UserDataManager: ObservableObject {
    @Published var person = Person()
    let db = Firestore.firestore()

    func setCurrentUser() {
        
        if Auth.auth().currentUser != nil {
            let userUID = Auth.auth().currentUser?.uid
            
            db.collection("Persons").document(userUID!).getDocument{snapshot, error in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    print("Get user id")
                    let userName = snapshot?.get("name") ?? ""
                    let userEmail = snapshot?.get("email") ?? ""
                    let userCalorie = snapshot?.get("dailyCalorieGoal") ?? 2000
                    self.person.name = userName as! String
                    self.person.email = userEmail as! String
                    self.person.dailyCalorieGoal = userCalorie as! Int
                }
            }
        } 
    }
    
    
    func createNewUser() {

        if Auth.auth().currentUser != nil {
            let userUID = Auth.auth().currentUser?.uid
            let userName =  Auth.auth().currentUser?.displayName
            let userEmail =  Auth.auth().currentUser?.email
            
            db.collection("Persons").document(userUID!).setData([
                "name": userName,
                "email": userEmail,
                "dailyCalorieGoal": 2500
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    self.person.name = userName!
                    self.person.email = userEmail!
                    self.person.dailyCalorieGoal = 2500
                    print("Document successfully written!")
                }
            }
        }
    }
    
    func updateUser(newCaloriesGoal:Int) {
        let userUID = Auth.auth().currentUser?.uid
        let ref = db.collection("Persons").document(userUID!)
        
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let document: DocumentSnapshot
            do {
                try document = transaction.getDocument(ref)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldCalorie = document.data()?["dailyCalorieGoal"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve dailyCalorieGoal from snapshot \(document)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }

            transaction.updateData(["dailyCalorieGoal": newCaloriesGoal], forDocument: ref)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
}
//    func checkUsername(userEmail: String, completion: @escaping (Bool) -> Void) {
//
//        // Get your Firebase collection
//        let collectionRef = db.collection("Persons")
//
//        // Get all the documents where the field username is equal to the String you pass, loop over all the documents.
//
//        collectionRef.whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, err) in
//            if let err = err {
//                print("Error getting document: \(err)")
//            } else if (snapshot?.isEmpty)! {
//                completion(false)
//            } else {
//                for document in (snapshot?.documents)! {
//                    if document.data()["username"] != nil {
//                        completion(true)
//                    }
//                }
//            }
//        }
//    }
//
        
        
        
        
//        let userUID = Auth.auth().currentUser?.uid
//        let docRef = db.collection("Persons").document(userUID!)
//
//        Firestore.firestore().collection("Persons").document(userUID!).getDocument { snapshot, error in
//            if error != nil {
//                print(error!.localizedDescription)
//                self.userSave()
//            }
//            else {
//                let userName = snapshot?.get("name") ?? ""
//                let userEmail = snapshot?.get("email") ?? ""
//                let userCalorie = snapshot?.get("dailyCalorieGoal") ?? 2000
//                self.person.name = userName as! String
//                self.person.email = userEmail as! String
//                self.person.dailyCalorieGoal = userCalorie as! Int
//            }
//        }
//
//    }
//
    
    
    
//    func addUser() {
//        let db = Firestore.firestore()
//        let currentUser = self.session.loggedUser
//        let userUID = currentUser?.uid
//        let userName = currentUser?.displayName
//        let userEmail = currentUser?.email
//
//        db.collection("Persons").document(userUID!).setData([
//            "name": userName,
//            "email": userEmail,
//            "dailyCalorieGoal": 2500
//        ]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//
//
//    }

//    init() {
//        fetchUser()
//    }
//
//    func userSave() {
//        let currentUser = Auth.auth().currentUser
//        let userUID = currentUser?.uid
//        let data = ["name": currentUser?.displayName ?? "", "email": currentUser?.email ?? "" , "dailyCalorieGoal":2000] as [String : Any]
//                Firestore.firestore().collection("Persons").document(userUID!).setData(data) { error in
//                    if error != nil {
//                        print(error!.localizedDescription)
//                        return
//                    }
//                    else {
//                        self.person.name = currentUser?.displayName ?? ""
//                        self.person.email = currentUser?.email ?? ""
//                        self.person.dailyCalorieGoal = 2000
//                    }
//                }
//    }
//
//    func fetchUser() {
//
//            let db = Firestore.firestore()
//
//            let userUID = Auth.auth().currentUser?.uid
//            let docRef = db.collection("Persons").document(userUID)
//
//            Firestore.firestore().collection("Persons").document(userUID!).getDocument { snapshot, error in
//                if error != nil {
//                    print(error!.localizedDescription)
//                    self.userSave()
//                }
//                else {
//                    let userName = snapshot?.get("name") ?? ""
//                    let userEmail = snapshot?.get("email") ?? ""
//                    let userCalorie = snapshot?.get("dailyCalorieGoal") ?? 2000
//                    self.person.name = userName as! String
//                    self.person.email = userEmail as! String
//                    self.person.dailyCalorieGoal = userCalorie as! Int
//                }
//            }
//        }
    
    
        
    

//    func fetchPerson() {
//        let db = Firestore.firestore()
//        let ref = db.collection("Persons")
//        ref.getDocuments{snapshot, error in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//
//            if let snapshot = snapshot {
//                for document in snapshot.documents {
//                    // Retrive all users
//                    let data = document.data()
//
//                    let email = data["email"] as? String ?? ""
//
//                    // if user email is same as current user email
//                    if email == self.loggedUserEmail {
//                        let name = data["name"] as? String ?? ""
//                        let dailyCalorieGoal = data["dailyCalorieGoal"] as? Int ?? 2000
//                        self.person.email = email
//                        self.person.name = name
//                        self.person.dailyCalorieGoal = dailyCalorieGoal
//                    }
//                }
//
//                if self.person.name == "Default User" && self.loggedUserEmail != nil {
//                    self.createPerson()
//                }
//            }
//        }
//    }
//
//    func createPerson() {
//        let db = Firestore.firestore()
//        let ref = db.collection("Persons")
//
//        ref.parent?.setData(["email":self.loggedUserEmail, "name":self.loggedUserName ?? "","dailyCalorieGoal":2500]) { error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//
//        self.person.email = self.loggedUserEmail ?? ""
//        self.person.name = self.loggedUserName ?? ""
//        self.person.dailyCalorieGoal = 2500
//
//    }

