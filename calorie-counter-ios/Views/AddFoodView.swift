//
//  AddFoodView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/1/22.
//

import SwiftUI

struct AddFoodView: View {
    
    @EnvironmentObject var viewModel:FoodViewModel
    @EnvironmentObject var userDatamManager:UserDataManager
    
    @State private var searchTerm = ""
    @State private var measureIndex = 0
    @State private var servingAmount = 1
    
    @State private var foodName: String = ""
    @State private var foodOptions: [FoodOption] = [FoodOption(name:"Default", measure:"Default", weight:1, calories:1)]
    
    @State private var showingEmptySearchAlert = false
    @State private var showingSuccessAdded = false
    
    var body: some View {
        VStack {
            Form {
                Section(header:Text("Search")) {
                        TextField("Enter Food", text:$searchTerm)
                    HStack(alignment: .center, spacing:20){
                        Spacer()
                        Button {
                            // show alert if empty input
                            if searchTerm == "" {
                                showingEmptySearchAlert.toggle()
                            } else {
                                Api().getInfo(search_term:searchTerm) { (foodDetail) in
                                    self.foodName = foodDetail.name
                                    self.foodOptions = getFoodOptionList(foodDetail: foodDetail)
                                }
                            }
                            
                        } label :{
                            ButtonTextView(label: "Search")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .alert(isPresented: $showingEmptySearchAlert, content:{
                            Alert(title: Text("Empty Search"))
                        })
                        
                        Button {
                            clearInput()
                        } label :{
                            ButtonTextView(label: "Clear")
                        }
                        Spacer()
                    }
                        
                    
                }
                Section (header:Text("Search Result"))  {
                    
                    TextField("Food Name...", text:$foodName)

                    Picker("Measurements", selection: $measureIndex) {
                        ForEach(0..<foodOptions.count, id: \.self) {
                            Text(" \(foodOptions[$0].measure), \(foodOptions[$0].weight) g, \(foodOptions[$0].calories) Kcal").tag($0)
                        }
                    }
                    HStack {
                        Text("Serving Amount")
                        TextField("Amount",value:$servingAmount, format: .number)
                            .foregroundColor(.gray)
                            .keyboardType(.decimalPad)
                        Image(systemName: "pencil")
                    }
                }
                
                Section (header:Text("Total Calories intake")) {
                    HStack {
                        Spacer()
                        Image(systemName: "flame")
                        Text("\(getTotalCalIntake()) Kcals")
                            .font(.system(size:18, weight:.bold))
                        Spacer()
                    }.foregroundColor(.red)
                    
                    
                    HStack {
                        Spacer()
                        Button {
                            viewModel.addFood(name: foodName, calorie: getTotalCalIntake(), user:userDatamManager.person)
                            clearInput()
                            showingSuccessAdded.toggle()
                        } label: {
                            ButtonTextView(label: "Add")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .alert(isPresented: $showingSuccessAdded, content:{
                            Alert(title: Text("Added!"))
                        })
                        Spacer()
                    }
                }
                
            }
        }
    }
    
    private func clearInput() {
        searchTerm = ""
        measureIndex = 0
        servingAmount = 1
        foodOptions = [FoodOption(name:"Default", measure:"Default", weight:1, calories:1)]
        foodName = ""
    }
    
    // get total cal per entry
    private func getTotalCalIntake() -> Int{
        var totalCalIntake = 0
        if foodOptions != [] {
            totalCalIntake = Int(foodOptions[measureIndex].calories * servingAmount)
        }
        return totalCalIntake
    }
    
    private func getFoodOptionList(foodDetail: FoodDetail) -> [FoodOption] {
        var foodOptions:[FoodOption] = []
        let name = foodDetail.name
        
        let mirror = Mirror(reflecting: foodDetail)
        for child in mirror.children {
            if child.label != "name" && child.label != "id" {
                let values:[Int] = child.value as! [Int]
                if !values.isEmpty {
                    let option = FoodOption(name:name, measure:child.label!, weight:values[0], calories:values[1])
                    foodOptions.append(option)
                }
            }
        }
        return foodOptions
    }

}

struct FoodOption: Identifiable, Hashable {
    let id = UUID()
    let name:String
    let measure:String
    let weight:Int
    var calories:Int
    
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
