//
//  AddItemView.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLoading: Bool = true
    var itemToEdit: Articulo?
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Cargando datos...")
                    .onAppear {
                        if let itemToEdit = itemToEdit {
                            viewModel.name = itemToEdit.name ?? ""
                            viewModel.quantity = Int(itemToEdit.quantity)
                            viewModel.priority = itemToEdit.priority ?? "Low"
                            viewModel.notes = itemToEdit.notes ?? ""
                            
                            if let categoryName = itemToEdit.category {
                                viewModel.selectedCategory = viewModel.categories.first(where: { $0.name == categoryName })
                            }
                            
                            if let storeNames = itemToEdit.stores {
                                let storeNamesArray = storeNames.split(separator: ",").map { String($0) }
                                viewModel.selectedStores = viewModel.stores.filter { storeNamesArray.contains($0.name) }
                            }
                        }
                        
                        Task {
                            await viewModel.fetchData()
                            isLoading = false
                        }
                    }
            } else {
                Form {
                    Section(header: Text("Información del artículo")) {
                        TextField("Nombre", text: $viewModel.name)
                        Stepper("Cantidad: \(viewModel.quantity)", value: $viewModel.quantity, in: 1...100)
                    }
                    
                    Section(header: Text("Categoría")) {
                        Picker("Seleccionar categoría", selection: $viewModel.selectedCategory) {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Text(category.name).tag(category as Category?)
                            }
                        }
                    }
                    Section(header: Text("Tiendas")) {
                        Menu {
                            ForEach(viewModel.stores, id: \.self) { store in
                                Button(action: {
                                    if viewModel.selectedStores.contains(store) {
                                        viewModel.selectedStores.removeAll { $0 == store }
                                    } else {
                                        viewModel.selectedStores.append(store)
                                    }
                                }) {
                                    HStack {
                                        Text(store.name)
                                        if viewModel.selectedStores.contains(store) {
                                            Spacer()
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text("Seleccionar tiendas")
                                Spacer()
                                Text(viewModel.selectedStores.isEmpty ? "Ninguna" : "\(viewModel.selectedStores.count) seleccionadas")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Section(header: Text("Prioridad")) {
                        Picker("Seleccionar prioridad", selection: $viewModel.priority) {
                            Text("Alta").tag("High")
                            Text("Baja").tag("Low")
                        }
                    }
                    
                    Section(header: Text("Notas")) {
                        TextField("Notas opcionales", text: $viewModel.notes)
                    }
                }
                .navigationTitle(itemToEdit == nil ? "Agregar artículo" : "Editar artículo")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(itemToEdit == nil ? "Guardar" : "Actualizar") {
                            if let _ = itemToEdit {
                                viewModel.editItem()
                            } else {
                                viewModel.addItem()
                            }
                            viewModel.resetFields()
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") {
                            viewModel.resetFields()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
