//
//  ProductsView.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 22/05/2023.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewmodel = ProductsViewModel()
    var body: some View {
        List {
            ForEach(viewmodel.products) { product in
                ProductCellView(product: product)
                    .contextMenu {
                                            Button("Add to favorites") {
                                                viewmodel.addUserFavoriteProduct(productId: product.id)
                                            }
                                        }
                if product == viewmodel.products.last {
                    ProgressView()
                        .onAppear {
                            viewmodel.getProducts()
                            
                        }
                }
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
                  ToolbarItem(placement: .navigationBarLeading) {
                      Menu("Filter: \(viewmodel.selectedFilter?.rawValue ?? "NONE")") {
                          ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { option in
                              Button(option.rawValue) {
                                  Task {
                                      try? await viewmodel.filterSelected(option: option)
                                  }
                              }
                          }
                      }
                  }
                  
                  ToolbarItem(placement: .navigationBarTrailing) {
                      Menu("Category: \(viewmodel.selectedCategory?.rawValue ?? "NONE")") {
                          ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { option in
                              Button(option.rawValue) {
                                  Task {
                                      try? await viewmodel.categorySelected(option: option)
                                  }
                              }
                          }
                      }
                  }
        })
        .onAppear {
            viewmodel.getProducts()
            
            
        }
        
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProductsView()
        }
    }
}

struct ProductCellView: View {
    let product: Product
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0 , y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Price: $" + String(product.price ?? 0))
                Text("Rating: " + String(product.rating ?? 0))
                Text("Category: " + (product.category ?? "n/a"))
                Text("Brand: " + (product.brand ?? "n/a"))
            }
            .font(.callout)
            .foregroundColor(.secondary)
            
            
        }
    }
}
struct ProductCellViewBuilder: View {
    
    let productId: String
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)
            }
        }
        .task {
            self.product = try? await ProductManager.shared.getProduct(productId: productId)
        }
    }
}

