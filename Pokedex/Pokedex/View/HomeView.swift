//
//  HomeView.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/5/24.
//

import Foundation
import SwiftUI



struct HomeView: View {
    @ObservedObject var viewModel = PokemonViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Captured Pokémon row at the top if any
                    if !viewModel.capturedPokemon.isEmpty {
                        PokemonRow(viewModel: viewModel, title: "Captured Pokémon", pokemons: viewModel.capturedPokemon)
                    }
                    
                    // Rows by Pokémon type
                    ForEach(PokemonType.allCases, id: \.self) { type in
                        let pokemonsOfType = viewModel.pokemonList.filter { $0.types.contains(type) }
                        PokemonRow(viewModel: viewModel, title: type.rawValue, pokemons: pokemonsOfType)
                    }
                    
                    // Navigation link to full list of Pokémon
                    NavigationLink(destination: PokemonListView(viewModel: viewModel)) {
                        Text("View All Pokémon")
                            .font(.headline)
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Pokedex")
        }
    }
}


#Preview {
    HomeView()
}
