//
//  FoodLogView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/1/22.
//

import SwiftUI
import CoreData

struct FoodLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntity.date, ascending: false)],
        animation: .default)
        private var foods: FetchedResults<FoodEntity>
    
    var body: some View {
        VStack{
            List {
                ForEach(foods) { food in
                    Text(food.name ?? "")
                }
                .onDelete(perform: deleteFood)
            }
        }
    }
    
    private func deleteFood(offsets:IndexSet) {
        withAnimation {
            offsets.map{ foods[$0] }.forEach(viewContext.delete)
            saveFood(context:viewContext)
        }
    }
}

struct FoodLogView_Previews: PreviewProvider {
    static var previews: some View {
        FoodLogView()
    }
}
