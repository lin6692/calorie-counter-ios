//
//  Persistence.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/7/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory:true)
        let viewContext = result.container.viewContext
        for x in 0..<10 {
            let newFood = FoodEntity(context: viewContext)
            newFood.calorie = 100
            newFood.date = Date()
            newFood.name = "Apple \(x)"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name:"calorie-counter-ios")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

func saveFood(context:NSManagedObjectContext) {
    do {
        try context.save()
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
}

func getAllFoods() -> [FoodEntity] {
    let fetchRequest: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
    do {
        return try PersistenceController().container.viewContext.fetch(fetchRequest)
       } catch {
           print("Failed to fetch movies: \(error)")
           return []
       }
    
}

func totalCaloriesToday() -> Int {
    var caloriesToday:Int = 0
    var foods = getAllFoods()
    for food in foods {
        if Calendar.current.isDateInToday(food.date!) {
            caloriesToday += Int(food.calorie)
        }
    }
    return caloriesToday
}
