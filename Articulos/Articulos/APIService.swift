//
//  APIService.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

// APIService.swift
import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    private let baseUrl = "https://api.escuelajs.co/api/v1"
    
    private var getCategoriesUrl: String { "\(baseUrl)/categories" }
    private var getStoresUrl: String { "\(baseUrl)/stores" }
    
    func getCategories() async throws -> [Category] {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(getCategoriesUrl)
                .validate()
                .responseDecodable(of: [Category].self) { response in
                    switch response.result {
                    case .success(let categories):
                        continuation.resume(returning: categories)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    func getStores() async throws -> [Store] {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(getStoresUrl)
                .validate()
                .responseDecodable(of: [Store].self) { response in
                    switch response.result {
                    case .success(let stores):
                        continuation.resume(returning: stores)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
