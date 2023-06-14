//
//  TabBarView.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 27/05/2023.
//

import SwiftUI

struct TabBarView: View {
    @Binding var showSignInView: Bool
       
       var body: some View {
           TabView {
               NavigationStack {
                   ProductsView()
               }
               .tabItem {
                   Image(systemName: "cart")
                   Text("Products")
               }
               
               NavigationStack {
                   FavoriteView()
               }
               .tabItem {
                   Image(systemName: "star.fill")
                   Text("Favorites")
               }
               
               NavigationStack {
    
                   Profileview(showSignInView: $showSignInView)
               }
               .tabItem {
                   Image(systemName: "person")
                   Text("Profile")
               }
           }
       }
   }


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(showSignInView: .constant(false))
    }
}
