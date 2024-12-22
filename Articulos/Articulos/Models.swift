//
//  Models.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

// Models.swift
import Foundation

struct Category: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

struct Store: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}
