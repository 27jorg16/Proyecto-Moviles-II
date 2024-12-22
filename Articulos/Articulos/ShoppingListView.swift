//
//  ShoppingListView.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import SwiftUI

struct ShoppingListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = ShoppingListViewModel(context: PersistenceController.shared.container.viewContext)
    
    @State private var isAddingItem = false
    @State private var isEditingItem: Articulo? = nil
    @State private var selectedItems: Set<Articulo> = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Button(action: {
                                isEditingItem = item
                            }) {
                                HStack {
                                    Text(item.name ?? "Sin nombre")
                                        .font(.headline)
                                    Text("Cantidad: \(item.quantity)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.clear)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(Color.clear)
                            .cornerRadius(8)
                        }

                        VStack {
                            Button(action: {
                                viewModel.toggleItemPurchaseStatus(for: item)
                            }) {
                                Text(item.isPurchased ? "Comprado" : "No Comprado")
                                    .font(.headline)
                                    .foregroundColor(item.isPurchased ? .green : .red)
                                    .padding(8)
                                    .background(Capsule().stroke(item.isPurchased ? Color.green : Color.red, lineWidth: 2))
                            }
                            .frame(width: 120, height: 40)
                        }
                    }
                    .padding(.vertical, 8)
                    .contextMenu {
                        Button(action: {
                            viewModel.promptDelete(item: item)
                        }) {
                            Label("Eliminar", systemImage: "trash")
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.promptDelete(item: viewModel.items[index])
                    }
                }
            }
            .navigationTitle("Lista de compras")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.resetFields()
                        isAddingItem = true
                    }) {
                        Label("Agregar", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Marcar todo") {
                            for item in viewModel.items {
                                viewModel.toggleItemPurchaseStatus(for: item)
                            }
                        }
                        Button("Eliminar seleccionados") {
                            for item in selectedItems {
                                viewModel.deleteItem(item)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $isAddingItem) {
                AddItemView(viewModel: viewModel)
            }
            .sheet(item: $isEditingItem) { item in
                ItemDetailView(viewModel: viewModel, item: item)
            }
            .alert(isPresented: $viewModel.showingDeleteAlert) {
                Alert(
                    title: Text("Confirmar eliminación"),
                    message: Text("¿Estás seguro de que quieres eliminar este artículo?"),
                    primaryButton: .destructive(Text("Eliminar")) {
                        viewModel.confirmDelete()
                    },
                    secondaryButton: .cancel {
                        viewModel.cancelDelete()
                    }
                )
            }
            .navigationBarItems(trailing: NavigationLink("Ver Resumen", destination: SummaryView(viewModel: viewModel)))
        }
    }
}
