//
//  ItemDetailView.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var isDeleting = false
    
    var item: Articulo
    
    @State private var showDeleteConfirmation = false
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Cargando detalles...")
                    .onAppear {
                        isLoading = false
                    }
            } else {
                Form {
                    Section(header: Text("Información del artículo")) {
                        Text(item.name ?? "Sin nombre")
                        Text("Cantidad: \(item.quantity)")
                        Text("Prioridad: \(item.priority ?? "Baja")")
                        Text("Notas: \(item.notes ?? "Sin notas")")
                    }
                    
                    Section(header: Text("Categoría")) {
                        Text(item.category ?? "Sin categoría")
                    }
                    
                    Section(header: Text("Tiendas")) {
                        Text(item.stores ?? "No asociadas")
                    }
                    
                    Section {
                        Button("Editar") {
                            viewModel.itemToEdit = item // Establece el artículo para editar
                            isEditing = true
                        }
                    }
                    
                    Section {
                        Button("Eliminar artículo") {
                            showDeleteConfirmation = true
                        }
                        .foregroundColor(.red)
                    }
                }
                .navigationTitle("Detalles del artículo")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cerrar") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            // Pasa el artículo seleccionado para editar
            AddItemView(viewModel: viewModel, itemToEdit: item)
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Confirmar eliminación"),
                message: Text("¿Estás seguro de que deseas eliminar este artículo?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    viewModel.deleteItem(item)
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
