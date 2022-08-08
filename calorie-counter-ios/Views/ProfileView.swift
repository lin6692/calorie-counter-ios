//
//  ProfileView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/1/22.
//

import SwiftUI
import Combine

struct ProfileView: View {
    
    @State var user = "Lin"
    @State var email = "linliu6660@gmail.com"
    @State var goal = 2000
    
    @State private var age = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var genderArray = ["Other","Male", "Female"]
    @State private var genderIndex = 0
    @State private var calulcatedCal = "0"
    
    @State private var showingAlert = false
    
    
    var body: some View {
        return VStack {
            Form {
                
                // Display Person Information
                Section (header:Text("Personal Info")){
                    ProfileDetailEntryView(text: $user, img: "person.fill")
                    ProfileDetailEntryView(text: $email, img: "mail")
                    HStack{
                        Image(systemName: "flame")
                        Text("Daily Calorie Goal : \(goal) Kcal")
                    }
                }
                
                // Calculate daily calorie intake
                Section (header:Text("Calorie Calculator")) {
                    
                    // age input
                    TextInputIntView(tag: "Age", val: $age)
                    
                    // weight input
                    HStack {
                        TextInputIntView(tag: "Weight", val:$weight)
                        Text("kg").foregroundColor(.gray)
                    }
                    
                    // height input
                    HStack {
                        TextInputIntView(tag: "Height", val:$height)
                        Text("cm").foregroundColor(.gray)
                    }
                    
                    // gender input
                    Picker(selection: $genderIndex, label: Text ("Gender")) {
                        ForEach(0..<3) {
                            Text(self.genderArray[$0])
                        }
                    }
                    
                    // show result
                    HStack {
                        Text("Result")
                        Spacer()
                        HStack {
                            Spacer()
                            TextInputIntView(tag:calulcatedCal, val:$calulcatedCal)
                            Text("Kcal").foregroundColor(.gray)
                        }
                    }
                    
                    // get and update button
                    // **************** "UPDATE" function *********************
                    HStack (alignment: .center, spacing:20) {
                        Spacer()
                        Button {
                            if age == "" || weight == "" || height == "" {
                                showingAlert.toggle()
                            } else {
                                calulcatedCal = String(calculateCalories(gender: genderArray[genderIndex], age:  Int(age) ?? 0, weight: Int(weight) ?? 0, height: Int(height) ?? 0))
                            }
                        } label:{
                            ButtonTextView(label: "Get")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .alert(isPresented: $showingAlert, content:{
                            Alert(title: Text("Please enter all personal information"))
                        })
                        
                        Button {
                            goal = Int(calulcatedCal)!
                        } label:{
                            ButtonTextView(label: "Update")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }

                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink(destination: LoginView(), label:{
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    })
                }
            }
        }
    }
    
    private func calculateCalories(gender:String, age:Int, weight:Int, height:Int) -> Int{
        var fBMR: Double
        var mBMR: Double
        var oBMR: Double
        
        let fweightFactor = 9.563 * Double(weight)
        let fheightFactor = 1.850 * Double(height)
        let fageFactor = 4.676 * Double(age)
        fBMR = 655.1 + fweightFactor + fheightFactor + fageFactor
        
        let mweightFactor = 13.75 * Double(weight)
        let mheightFactor = 5.003 * Double(height)
        let mageFactor = 6.755 * Double(age)
        mBMR = 66.47 + mweightFactor + mheightFactor + mageFactor
        
        oBMR = (fBMR + mBMR)/2
        
        if gender == "Female" {
            return Int(fBMR)
        } else if gender == "Male" {
            return Int(mBMR)
        }
        return Int(oBMR)
    }
}

struct ProfileDetailEntryView: View {
    @Binding var text:String
    var img: String
    var body: some View {
        HStack{
            Image(systemName: img)
            Text(text)
        }
    }
}

struct TextInputIntView: View {
    var tag: String
    @Binding var val: String
    
    var body: some View {
            // Enforce User to enter Digits
            TextField(tag,text:$val).keyboardType(.numberPad)
                .onReceive(Just(val)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.val = filtered
                    }}
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
