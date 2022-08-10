//
//  HomeView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/1/22.
//

import SwiftUI
import CoreData
import Firebase
import GoogleSignIn

struct HomeView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject var userDataManager = UserDataManager()
    @StateObject var viewModel = FoodViewModel()
    @State var pieChartLabel = ["current", "remaining"]
    
    var body: some View {
        if session.loggedUser != nil {
            NavigationView {
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
                        CalorieDisplay(number: userDataManager.person.dailyCalorieGoal, desc: "Goal")
                        Text("-").fontWeight(.bold)
                        CalorieDisplay(number: viewModel.totalCaloriesToday(user: userDataManager.person), desc: "Current")
                        Text("=").fontWeight(.bold)
                        CalorieDisplay(number: viewModel.getRemaining(goal: userDataManager.person.dailyCalorieGoal), desc: "Remaining")
                    }
                    
                    // Pie chart to display the percentage
                    PieChart(data: viewModel.getProgress(goal:userDataManager.person.dailyCalorieGoal), labels: $pieChartLabel, colors: [.red, .yellow, .blue], borderColor: .white)
                        .padding(40)
                        .frame(height: 380)
                    
                    NavigationLink(destination: FoodLogView(), label:{
                        Text("LOG")
                    })
                    
                    
                    
                    Spacer()
                    
                }
                .onAppear{
                    self.userDataManager.setCurrentUser()
                    if userDataManager.person.name == "" {
                        self.userDataManager.createNewUser()
                    }
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
                
            }.environmentObject(viewModel)
                .environmentObject(userDataManager)
        } else {
            LoginView()
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct CalorieDisplay: View {
    var number:Int
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
