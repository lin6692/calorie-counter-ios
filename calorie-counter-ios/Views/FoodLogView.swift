//
//  FoodLogView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/1/22.
//

import SwiftUI
import CoreData

struct FoodLogView: View {
    
    @EnvironmentObject var viewModel:FoodViewModel
    @EnvironmentObject var userDataManager:UserDataManager
    @EnvironmentObject var session: SessionManager
    
    var body: some View {
        VStack{
            Text("\(viewModel.calorieToday) Kcal (Today)")
                .foregroundColor(.gray)
                .padding(.horizontal)
            List {
                ForEach(viewModel.foods) { food in
                    if food.userEmail == userDataManager.person.email {
                        FoodEntryView(food: food)
                    }
                }
                .onDelete(perform: viewModel.deleteFood)
            }
            .listStyle(PlainListStyle())
        }
        .onAppear{
            viewModel.calorieToday = viewModel.totalCaloriesToday(user: userDataManager.person)
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
