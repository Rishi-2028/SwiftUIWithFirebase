//
//  ProductManager.swift
//  FirebaseBootcamp
//
//  Created by Rishi on 22/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProductManager {
    
    // Singleton instance
    static let shared = ProductManager()
    private init() {}
    
    
    // Firestore collection reference for products
    private let productsCollection = Firestore.firestore().collection("products")
    
    
    // Method returns a DocumentReference for a specific product ID.
    private func productDocument(productId: String) ->  DocumentReference {
        productsCollection.document(productId)
        
    }
    //Method to upload a product to Firestore.
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    //  Method retrieves a specific product from Firestore based on its ID.
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    
    private func getAllProductsQuery() -> Query {
           productsCollection
       }
       
       private func getAllProductsSortedByPriceQuery(descending: Bool) -> Query {
           productsCollection
               .order(by: Product.CodingKeys.price.rawValue, descending: descending)
       }
       
       private func getAllProductsForCategoryQuery(category: String) -> Query {
           productsCollection
               .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
       }
       
       private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
           productsCollection
               .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
               .order(by: Product.CodingKeys.price.rawValue, descending: descending)
       }
       
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
           var query: Query = getAllProductsQuery()

           if let descending, let category {
               query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
           } else if let descending {
               query = getAllProductsSortedByPriceQuery(descending: descending)
           } else if let category {
               query = getAllProductsForCategoryQuery(category: category)
           }
        
        return try await query
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Product.self)
       }
    
    func getProductsByRating(count: Int, lastRating: Double?) async throws -> [Product] {
            try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .start(after: [lastRating ?? 9999999])
                .getDocuments(as: Product.self)
        }
        
        func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
            if let lastDocument {
                return try await productsCollection
                    .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                    .limit(to: count)
                    .start(afterDocument: lastDocument)
                    .getDocumentsWithSnapshot(as: Product.self)
            } else {
                return try await productsCollection
                    .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                    .limit(to: count)
                    .getDocumentsWithSnapshot(as: Product.self)
            }
        }
}

