//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonViewModel
    @State private var selectedType: PokemonType? = nil

    var filteredPokemonList: [Pokemon] {
        if let selectedType = selectedType {
            return viewModel.pokemonList.filter { $0.types.contains(selectedType) }
        }
        return viewModel.pokemonList
    }

    var body: some View {
        VStack {
            Picker("Filter by Type", selection: $selectedType) {
                Text("None").tag(nil as PokemonType?)
                ForEach(PokemonType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type as PokemonType?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            List(filteredPokemonList) { pokemon in
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon, viewModel: viewModel)) {
                    HStack {
                        Image(pokemon.formattedID)
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("#\(pokemon.formattedID)")
                                .font(.caption)
                            Text(pokemon.name)
                                .font(.headline)
                        }
                        if pokemon.captured ?? false {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("All Pokemon")
        }
    }
}


extension LinearGradient {
    init(pokemon: Pokemon) {
        let colors = pokemon.types.map { Color(pokemonType: $0) }
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


