//
//  HomeView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/1/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var goal = 2000
    @State var current = 400
    @State var remaining = 1600
    
    @State var testData = [0.3,0.7]
    @State var pieChartLabel = ["current", "remaining"]

    
    var body: some View {
         return NavigationView {
            VStack{
                // Display the date of Today
                VStack (alignment:.leading, spacing:10) {
                    Text("Today")
                        .font(.system(size:30 , weight:.medium,design: .default))
                        .foregroundColor(.accentColor)
                        .padding(.leading, 40)
                    
                    Text(Date.now, format: .dateTime.day().month().year())
                        .padding(.leading, 40)
                        .font(.system(size:16, weight:.light, design:.default))
                        .foregroundColor(Color.black.opacity(0.8))
                }
                .frame(width: 380, alignment:.leading)
                .padding(.top,30)
                .font(.system(size:24 , weight:.medium,design: .default))
                .foregroundColor(.black)
                .padding()
                
                
                // Display Current Kcal Details
                HStack {
                    CalorieDisplay(number: $goal, desc: "Goal")
                    Text("-").fontWeight(.bold)
                    CalorieDisplay(number: $current, desc: "Current")
                    Text("=").fontWeight(.bold)
                    CalorieDisplay(number: $remaining, desc: "Current")
                }
                
                // Pie chart to display the percentage
                PieChart(data: $testData, labels: $pieChartLabel, colors: [.red, .yellow, .blue], borderColor: .white)
                    .padding(40)
                    .frame(height: 380)
                
                NavigationLink(destination: FoodLogView(), label:{
                    Text("LOG")
                })
                
                Spacer()
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(), label:{
                        Image(systemName: "person.crop.circle")
                    })
                    NavigationLink(destination: AddFoodView(), label:{
                        Image(systemName: "plus.circle")
                    })
                }
            }
            .navigationBarTitle(Text("Home"), displayMode: .inline)
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct CalorieDisplay: View {
    @Binding var number:Int
    var desc:String
    
    var body: some View {
        VStack{
            Text(String(number))
                .font(.system(size:26 , weight:.medium,design: .default))
                .foregroundColor(.black)
            Text(desc)
                .font(.system(size:16 , weight:.medium,design: .default))
                .foregroundColor(.black)
        }
    }
}
