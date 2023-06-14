//
//  AuthenticationView.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 28/03/2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth


struct AuthenticationView: View {
    @StateObject private var viewmodel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        
        VStack {
            NavigationLink {
                SignInEmailView( showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewmodel.signInGoogle()
                        showSignInView = false
                        
                    } catch {
                        print(error)
                        
                    }
                }
            }
            
            
            
            
            
            
            Spacer()

        }
        .padding()
        .navigationTitle("Sign In")
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(true))
        }
    }
}
