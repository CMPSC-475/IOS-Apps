//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var viewModel: PokemonViewModel
    @State private var isCaptured: Bool
    
    init(pokemon: Pokemon, viewModel: PokemonViewModel) {
        self.pokemon = pokemon
        self.viewModel = viewModel
        self._isCaptured = State(initialValue: pokemon.captured ?? false)
    }
    
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            Image(pokemon.formattedID)
                .resizable()
                .frame(width: 150, height: 150)
            
            Text(pokemon.name)
                .font(.largeTitle)
                .bold()
            
            Button(action: {
                isCaptured.toggle()
                viewModel.updateCaptureStatus(for: pokemon, captured: isCaptured)
            }) {
                Text(isCaptured ? "Release" : "Capture")
                    .font(.headline)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(isCaptured ? .red : .green))
                    .foregroundColor(.white)
            }
            
            if let prevEvolutions = viewModel.previousEvolutions(for: pokemon) {
                PokemonRow(viewModel: viewModel, title: "Previous Evolutions", pokemons: prevEvolutions)
            }
            if let nextEvolutions = viewModel.nextEvolutions(for: pokemon) {
                PokemonRow(viewModel: viewModel, title: "Next Evolutions", pokemons: nextEvolutions)
            }
        }
        .navigationTitle(pokemon.name)
        .padding()
    }
}


