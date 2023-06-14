//
//  Profileview.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 20/04/2023.
//

import SwiftUI
import PhotosUI



struct Profileview: View {
    
    @StateObject private var viewmodel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    
    let preferenceOptions: [String] = ["Sports", "Books", "Movies"]
    
    private func preferenceIsSelected(text: String) -> Bool {
        viewmodel.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List {
            if let user = viewmodel.user {
                Text("UserId: \(user.userId)")
                    .foregroundColor(.black)
                
                Button {
                    viewmodel.togglePremiumStatus()
                } label: {
                    
                    Text("User is Premium: \((user.isPremium ?? false).description.capitalized)")
                    
                }
                VStack {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { string in
                            Button(string) {
                                if preferenceIsSelected(text: string){
                                    viewmodel.removeUserPreference(text: string)
                                } else {
                                    viewmodel.addUserPreference(text: string)
                                }
                                
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(preferenceIsSelected(text: string) ? .green : .red)
                        }
                    }
                    
                    Text("User Preferences: \((user.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                Button {
                    if user.favoriteMovie == nil {
                        viewmodel.addFavoriteMovie()
                    } else {
                        viewmodel.removeFavoriteMovie()
                    }
                    
                } label: {
                    
                    Text("Favorite Movie: \((user.favoriteMovie?.title ?? "" )) ")
                    
                }
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                
                
                if let urlString = viewmodel.user?.profileImagePathUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                }
                
                if viewmodel.user?.profileImagePath != nil {
                    Button("Delete image") {
                        viewmodel.deleteProfileImage()
                    }
                }
            }

            
        }
        .task {
           try?  await viewmodel.loadCurrentUser()
        }
        .onChange(of: selectedItem, perform: { newValue in
                    if let newValue {
                        viewmodel.saveProfileImage(item: newValue)
                    }
                })
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }

                
            }
        }
    }
}

struct Profileview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RootView()
        }
    }
}
