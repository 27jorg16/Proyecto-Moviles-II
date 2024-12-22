//
//  Persistence.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Articulos")
        container.loadPersistentStores { _, error in
            if let er = error as NSError? {
                fatalError("Error al conectarse a la BD, \(er.localizedDescription)")
            }
        }
    }
}
