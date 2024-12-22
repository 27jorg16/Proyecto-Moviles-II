//
//  SummaryView.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Resumen General")) {
                    Text("Total de artículos: \(viewModel.items.count)")
                    Text("Artículos comprados: \(viewModel.purchasedItemsCount)")
                    Text("Artículos pendientes: \(viewModel.pendingItemsCount)")
                }
                
                Section(header: Text("Desglose por Categoría")) {
                    ForEach(viewModel.categoryBreakdown, id: \.category) { breakdown in
                        Text("\(breakdown.category): \(breakdown.pending) pendientes, \(breakdown.purchased) comprados")
                    }
                }
                
                Section(header: Text("Desglose por Tienda")) {
                    ForEach(viewModel.storeBreakdown, id: \.store) { breakdown in
                        Text("\(breakdown.store): \(breakdown.pending) pendientes, \(breakdown.purchased) comprados")
                    }
                }
            }
            .navigationTitle("Resumen de Compras")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        // Acción para actualizar, si fuera necesario
                    }) {
                        Label("Actualizar", systemImage: "arrow.clockwise")
                    }
                }
            }
        }
    }
}
