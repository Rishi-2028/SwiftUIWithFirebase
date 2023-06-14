//
//  SettingViewModel.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 20/04/2023.
//

import Foundation
@MainActor
final class SettingViewModel : ObservableObject {
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
       
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
        
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updatePassword() async throws {
        let password = "soneeka123"
        try await AuthenticationManager.shared.updateEmail(email: password)
    }
    
    func updateEmail() async throws {
        let email = "soneeka@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    
}
