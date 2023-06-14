//
//  SettingView.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 28/03/2023.
//

import SwiftUI


struct SettingView: View {
    @StateObject private var vm = SettingViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                       try vm.signOut()
                        showSignInView = true
                    } catch {
                        print("Error\(error)")
                    }
                }
            }
            if vm.authProviders.contains(.email) {
                emailSection
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await vm.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("Error\(error)")
                    }
                }
            } label: {
                Text("Delete Account")
            }

            
            

            
        }
        .onAppear{
            vm.loadAuthProviders()
        }
        .navigationTitle("Settings")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingView(showSignInView: .constant(false))
        }
        
    }
}

extension SettingView {
    private var emailSection: some View {
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await vm.resetPassword()
                        showSignInView = true
                    } catch {
                        print("Error\(error)")
                    }
                }
            }
            Button("Update Password") {
                Task {
                    do {
                        try await vm.updatePassword()
                        showSignInView = true
                    } catch {
                        print("Error\(error)")
                    }
                }
            }
            Button("Update Email") {
                Task {
                    do {
                        try await vm.updateEmail()
                        showSignInView = true
                    } catch {
                        print("Error\(error)")
                    }
                }
            }
        } header: {
            Text("Email Section")
        }
    }
}
