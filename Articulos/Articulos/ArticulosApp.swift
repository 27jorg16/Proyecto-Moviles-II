//
//  ArticulosApp.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import SwiftUI

@main
struct ArticulosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListaDeComprasView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
