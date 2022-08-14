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
        // if user is logged in, display HomeView; Otherwise display loginView
        if session.loggedUser != nil {
            NavigationView {
                ZStack{
                    
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
                    .offset(y:-300)
                    
                    
                    if viewModel.totalCaloriesToday(user: userDataManager.person) >= userDataManager.person.dailyCalorieGoal {
                        meetGoalView(person: userDataManager.person, viewModel: viewModel)
                    } else {
                        // Display Current Kcal Details
                        goalView(userDataManager: userDataManager, viewModel: viewModel, pieChartLabel: $pieChartLabel)
                    }
                    
                    NavigationLink(destination: FoodLogView(), label:{
                        ButtonTextView(label:"LOG")
                    }).offset(y:+270)
                    
                }
                .ignoresSafeArea()
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
            }
            .environmentObject(viewModel)
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
    var color:Color
    
    var body: some View {
        VStack{
            Text(String(number))
                .font(.system(size:26 , weight:.medium,design: .default))
                .foregroundColor(.black)
            Text(desc)
                .font(.system(size:16 , weight:.medium,design: .default))
                .foregroundColor(color)
        }
    }
}

struct goalView: View {
    var userDataManager: UserDataManager
    var viewModel: FoodViewModel
    @Binding var pieChartLabel: [String]
    
    var body: some View {
        
        // equation
        HStack {
            CalorieDisplay(number: userDataManager.person.dailyCalorieGoal, desc: "Goal",color:.black)
            Text("-").fontWeight(.bold)
            CalorieDisplay(number: viewModel.totalCaloriesToday(user: userDataManager.person), desc: "Current", color:Color("pie-red"))
            Text("=").fontWeight(.bold)
            CalorieDisplay(number: viewModel.getRemaining(user: userDataManager.person), desc: "Remaining", color:Color("pie-blue"))
        }.offset(y:-170)

        // Pie chart to display the percentage
        PieChart(data: viewModel.getProgress(user:userDataManager.person), labels: $pieChartLabel, colors: [Color("pie-red"), Color("pie-blue"), .blue], borderColor: .white)
            .padding(40)
            .frame(height: 380)
            .offset(y:+50)
    }
}

struct meetGoalView: View{
    var person: Person
    var viewModel: FoodViewModel
    
    var body: some View {
        VStack (spacing:60){
            VStack(spacing:10) {
                Text("Yay! You meet your daily goal")
                Text("\(person.dailyCalorieGoal) Calories")

            }
            .font(.title2)
            .foregroundColor(Color("white"))
            .frame(width: 320, height: 100, alignment: .center)
            .background(Color("pie-red"))
            .cornerRadius(30)
            
            VStack (spacing: 10){
                Text("Calorie Intake Today: \(viewModel.totalCaloriesToday(user: person))")
                Text("\(person.dailyCalorieGoal - viewModel.totalCaloriesToday(user: person)) calories excess")
                
            }
        }
        
    }
}
