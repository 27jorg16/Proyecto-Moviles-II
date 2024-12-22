//
//  ListaDeComprasView.swift
//  Articulos
//
//  Created by DAMII on 22/12/24.
//

import SwiftUI

struct ListaDeComprasView: View {
    @State private var isNavigating = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Lista de Compras")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                Image(uiImage: UIImage(named: "7662141.png")!)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .padding(.top, 30)
                
                Spacer(minLength: 50) 
                Button(action: {
                    isNavigating.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 60) // Espacio adicional para comodidad al pulgar
                .fullScreenCover(isPresented: $isNavigating) {
                    ShoppingListView() // Navegar a ShoppingListView
                }
            }
        }
        .navigationBarHidden(true) // Ocultar la barra de navegación
    }
}
