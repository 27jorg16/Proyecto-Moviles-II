//
//  ShoppingListViewModel.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import Foundation
import CoreData

class ShoppingListViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var quantity: Int = 1
    @Published var selectedCategory: Category? = nil
    @Published var selectedStores: [Store] = []
    @Published var priority: String = "Low"
    @Published var notes: String = ""
    
    @Published var categories: [Category] = []
    @Published var stores: [Store] = [
            Store(id: 1, name: "Metro"),
            Store(id: 2, name: "Wong"),
            Store(id: 3, name: "Totus"),
            Store(id: 4, name: "Makro"),
            Store(id: 5, name: "Plaza Vea"),
            Store(id: 6, name: "Tottus"),
            Store(id: 7, name: "Cencosud"),
            Store(id: 8, name: "Real Plaza")
        ]
    @Published var items: [Articulo] = []
    @Published var itemToEdit: Articulo? = nil
    
    @Published var itemToDelete: Articulo? = nil
    @Published var showingDeleteAlert: Bool = false
    
    var purchasedItemsCount: Int {
        items.filter { $0.isPurchased }.count
    }
        
    var pendingItemsCount: Int {
        items.filter { !$0.isPurchased }.count
    }
        
    var categoryBreakdown: [(category: String, purchased: Int, pending: Int)] {
        let categories = Set(items.compactMap { $0.category })
        return categories.map { category in
            let purchased = items.filter { $0.category == category && $0.isPurchased }.count
            let pending = items.filter { $0.category == category && !$0.isPurchased }.count
            return (category, purchased, pending)
        }
    }
        
    var storeBreakdown: [(store: String, purchased: Int, pending: Int)] {
        let stores = Set(items.compactMap { $0.stores })
        return stores.map { store in
            let purchased = items.filter { $0.stores == store && $0.isPurchased }.count
            let pending = items.filter { $0.stores == store && !$0.isPurchased }.count
            return (store, purchased, pending)
        }
    }
    
    let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchItems()
    }
    
    func fetchItems() {
        let request: NSFetchRequest<Articulo> = Articulo.fetchRequest()
        do {
            items = try viewContext.fetch(request)
        } catch {
            print("Error al cargar los artículos: \(error.localizedDescription)")
        }
    }
    
    func fetchData() async {
        do {
            self.categories = try await APIService.shared.getCategories()
            self.stores = try await APIService.shared.getStores()
        } catch {
            print("Error al cargar datos: \(error.localizedDescription)")
        }
    }
    
    func addItem() {
        let newItem = Articulo(context: viewContext)
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = Int16(quantity)
        newItem.category = selectedCategory?.name ?? "N/A"
        newItem.priority = priority
        newItem.notes = notes
        newItem.isPurchased = false
        newItem.stores = selectedStores.map { $0.name }.joined(separator: ", ")
        
        saveChanges()
        fetchItems()
        resetFields()
    }
    
    func editItem() {
        guard let itemToEdit = itemToEdit else { return }
            
        itemToEdit.name = name
        itemToEdit.quantity = Int16(quantity)
        itemToEdit.category = selectedCategory?.name ?? "N/A"
        itemToEdit.priority = priority
        itemToEdit.notes = notes
        itemToEdit.stores = selectedStores.map { $0.name }.joined(separator: ", ")
            
        saveChanges()
        fetchItems()
    }
    
    func deleteItem(_ item: Articulo) {
        viewContext.delete(item)
        saveChanges()
        fetchItems()
    }
    
    func toggleItemPurchaseStatus(for item: Articulo) {
        item.isPurchased.toggle()
        saveChanges()
        fetchItems()
    }
    
    private func saveChanges() {
        do {
            try viewContext.save()
        } catch {
            print("Error al guardar los cambios: \(error.localizedDescription)")
        }
    }
    
    func resetFields() {
        name = ""
        quantity = 1
        selectedCategory = nil
        selectedStores = []
        priority = "Low"
        notes = ""
    }
    
    func promptDelete(item: Articulo) {
        itemToDelete = item
        showingDeleteAlert = true
    }
    
    func confirmDelete() {
        if let itemToDelete = itemToDelete {
            deleteItem(itemToDelete)
            self.itemToDelete = nil
        }
        showingDeleteAlert = false
    }
    
    func cancelDelete() {
        itemToDelete = nil
        showingDeleteAlert = false
    }
}
