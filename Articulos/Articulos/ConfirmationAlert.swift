//
//  ConfirmationAlert.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import SwiftUI

struct ConfirmationAlert: View {
    @Binding var isPresented: Bool
    let onConfirm: () -> Void
    
    var body: some View {
        VStack {
            Text("Are you sure you want to delete this item?")
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                Button("Delete") {
                    onConfirm()
                    isPresented = false
                }
            }
        }
    }
}
