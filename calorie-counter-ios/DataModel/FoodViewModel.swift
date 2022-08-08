//
//  FoodViewModel.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/8/22.
//

import CoreData
import SwiftUI

class FoodViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var foods:[FoodEntity] = []
    @Published var calorieToday:Int  = 0
    
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
        do {
            foods = try container.viewContext.fetch(fetchRequest)
            calorieToday = totalCaloriesToday()
           } catch {
               print("Failed to fetch movies: \(error)")
           }
    }
    
    func addFood(name:String, calorie:Int) {
        let newFood = FoodEntity(context:container.viewContext)
        newFood.id = UUID()
        newFood.date = Date()
        newFood.name = name
        newFood.calorie = Int64(exactly: calorie)!
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
    
    func totalCaloriesToday() -> Int {
        var caloriesToday:Int = 0
//        getAllFoods()
        for food in foods {
            if Calendar.current.isDateInToday(food.date!) {
                caloriesToday += Int(food.calorie)
            }
        }
        return caloriesToday
    }
    
    func getRemaining(goal:Int) -> Int {
        var remaining:Int
        remaining = goal - self.calorieToday
        return remaining
    }
    
    func getProgress(goal:Int) -> [Double] {
        var current:Double
        var remaining:Double
        
        current = Double(self.calorieToday)/Double(goal)
        remaining = Double(self.getRemaining(goal:goal))/Double(goal)
        
        return [current, remaining]
    }
}
