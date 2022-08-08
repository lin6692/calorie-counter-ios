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
            Text("\(totalCaloriesToday()) Kcal (Today)")
                .foregroundColor(.gray)
                .padding(.horizontal)
            List {
                ForEach(foods) { food in
                    FoodEntryView(food:food)
                }
                .onDelete(perform: deleteFood)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Calorie Log")
    }
    
    private func deleteFood(offsets:IndexSet) {
        withAnimation {
            offsets.map{ foods[$0] }.forEach(viewContext.delete)
            saveFood(context:viewContext)
        }
    }
}

struct FoodEntryView: View {
    var food:FoodEntity
    var body: some View {
        return HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(food.name!)").bold()
                Text("\(Int(food.calorie))  ") + Text("calories").foregroundColor(.red)
            }
            Spacer()
            Text(calcTimeSince(date: food.date!))
                .foregroundColor(.gray)
                .italic()
        }
    }
}

struct FoodLogView_Previews: PreviewProvider {
    static var previews: some View {
        FoodLogView()
    }
}
