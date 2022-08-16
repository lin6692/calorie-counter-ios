//
//  LoginView.swift
//  calorie-counter-ios
//
//  Created by Lin Liu on 8/1/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {

    @State var isLoading: Bool = false

    
    var body: some View {
        
        ZStack {
            
            // set background image
            LinearGradient(colors: [.blue, .pink],
                                   startPoint: .top,
                                   endPoint: .center)
            
            Text("iCalories")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .offset(y:-200)
            
            // set google sign in button
            VStack{
                Button {
                    handleLogin()
                } label: {
                    HStack {
                        Spacer()
                        Image("google")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .padding(.horizontal)
                        Text("Sign in with Google")
                            .foregroundColor(.black)
                            .font(.title3)
                        Spacer()
                    }
                    .padding()
                    .frame(width:320)
                    .background(.white)
                    .cornerRadius(50.0)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                }
            }
            // set loading view
            .overlay(ZStack{
                if isLoading{
                    Color.black
                        .opacity(0.1)
                        .ignoresSafeArea()
                    ProgressView()
                        .font(.title2)
                        .frame(width: 60, height: 40)
                }
            }.cornerRadius(50.0)
            )
            
            VStack(spacing:7){
                HStack{
                    Text("Created by")
                    Link("Lin Liu", destination: URL(string: "https://github.com/lin6692/calorie-counter-ios")!)
                    Image(systemName: "heart.circle.fill")
                }
                Text("@ Ada Developer Academy, July 2022")
            }
            .offset(y:+320)
            .padding()
            .foregroundColor(Color("white"))
        }.ignoresSafeArea()
    }
    
    
    func handleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {
            [self]user, error in
            if let error = error {
                isLoading = false
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            //Firebase Auth
            Auth.auth().signIn(with: credential) { result, error in
                isLoading = false
                if let error = error {
                    
                    print(error.localizedDescription)
                    return
                }
                
                // display username
                guard let user = result?.user else {
                    return
                }
                
                print(user.displayName ?? "Success!")

            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View {
    //Retreiving RootView controller
    func getRootViewController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

