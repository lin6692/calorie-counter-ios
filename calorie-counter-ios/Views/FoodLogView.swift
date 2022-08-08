//
//  FoodLogView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/1/22.
//

import SwiftUI
import CoreData

struct FoodLogView: View {
    
    @StateObject var viewModel = FoodViewModel()
    
    var body: some View {
        VStack{
            Text("\(viewModel.totalCaloriesToday()) Kcal (Today)")
                .foregroundColor(.gray)
                .padding(.horizontal)
            List {
                ForEach(viewModel.foods) { food in
                    FoodEntryView(food: food)
                }
                .onDelete(perform: viewModel.deleteFood)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Calorie Log")
    }
    
}

struct FoodEntryView: View {
    var food:FoodEntity
    var body: some View {
        return HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(food.name!).bold()
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
