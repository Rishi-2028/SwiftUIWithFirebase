//
//  FavoriteView.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 27/05/2023.
//

import SwiftUI

struct FavoriteView: View {
    
    @StateObject private var viewmodel = FavoriteViewModel()
    
    var body: some View {
        List {
            ForEach(viewmodel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button("Remove from favorites") {
                            viewmodel.removeFromFavorites(favoriteProductId: item.id)
                        }
                    }
            }
        }
        .navigationTitle("Favorites")
        .onFirstAppear {
            viewmodel.addListenerForFavorites()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoriteView()
        }
    }
}


