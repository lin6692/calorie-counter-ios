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
        VStack{
            Button {
                handleLogin()
            } label: {
                Text("Sign In with google")
            }
        }.overlay(ZStack{
            if isLoading{
                Color.black
                    .opacity(0.25)
                    .ignoresSafeArea()
                ProgressView()
                    .font(.title2)
                    .frame(width: 60, height: 40)
            }
        })
       
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
