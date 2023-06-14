//
//  SignInEmailView.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 28/03/2023.
//

import SwiftUI

struct SignInEmailView: View {
    @StateObject var vm =  SignInEmailViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        VStack {
            TextField("Email...", text: $vm.email)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            SecureField("Password...", text: $vm.password)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            Button {
                Task {
                    do {
                        try await vm.signUp()
                        showSignInView = false
                        
                    } catch {
                        print(error)
                        
                    }
                    
                    do {
                        try await vm.signIn()
                        showSignInView = false
                        
                    } catch {
                        print(error)
                        
                    }
                }
                
                
                
                
                
            } label: {
                Text("Sign In ")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        
        .padding()
        .navigationTitle("Sign In With Email")
        
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
        
    }
}
