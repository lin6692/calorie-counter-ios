//
//  FoodViewModel.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/8/22.
//

import CoreData
import SwiftUI
import Firebase

class FoodViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var foods:[FoodEntity] = []
    
    
    init() {
        container = NSPersistentContainer(name:"calorie-counter-ios")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        getAllFoods()
    }
    
    func getAllFoods() {
        let fetchRequest: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
        let sort = NSSortDescriptor(keyPath: \FoodEntity.date, ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
//        let predicate = NSPredicate(format: "userUID == %@", userUID ?? "")
//        fetchRequest.predicate = predicate
        
        do {
            foods = try container.viewContext.fetch(fetchRequest)
           } catch {
               print("Failed to fetch movies: \(error)")
           }
    }
    

    
    func addFood(name:String, calorie:Int, user:Person) {
        let newFood = FoodEntity(context:container.viewContext)
        newFood.id = UUID()
        newFood.date = Date()
        newFood.name = name
        newFood.calorie = Int64(exactly: calorie)!
        newFood.userEmail = user.email
        saveFood()
    }
    
    func deleteFood(indexSet:IndexSet) {
        guard let index  = indexSet.first else {return }
        let food = foods[index]
        container.viewContext.delete(food)
        saveFood()
    }
    
    func saveFood() {
        do {
            try container.viewContext.save()
            getAllFoods()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func totalCaloriesToday(user:Person) -> Int {
        var caloriesToday:Int = 0
        for food in foods {
            if Calendar.current.isDateInToday(food.date!) && food.userEmail == user.email {
                caloriesToday += Int(food.calorie)
            }
        }
        return caloriesToday
    }
    
    func getRemaining(user:Person) -> Int {
        var remaining:Int
        remaining = user.dailyCalorieGoal - totalCaloriesToday(user:user)
        return remaining
    }
    
    func getProgress(user:Person) -> [Double] {
        var current:Double
        var remaining:Double
        
        current = Double(self.totalCaloriesToday(user:user))/Double(user.dailyCalorieGoal)
        remaining = Double(self.getRemaining(user:user))/Double(user.dailyCalorieGoal)
        
        if current >= 1.0 {
            return [1.0, 0.0]
        } else {
            return [current, remaining]
        }

    }
}
