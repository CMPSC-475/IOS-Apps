//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel = PokemonViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.pokemonList) { pokemon in
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                    HStack {
                        Image(pokemon.formattedID)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(LinearGradient(pokemon: pokemon))
                            )
                        VStack(alignment: .leading) {
                            Text("#\(pokemon.formattedID)")
                                .font(.caption)
                            Text(pokemon.name)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Pokedex")
        }
    }
}

extension LinearGradient {
    init(pokemon: Pokemon) {
        let colors = pokemon.types.map { Color(pokemonType: $0) }
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

#Preview {
    PokemonListView()
        //.environment(\.colorScheme, .light) // Light Mode
        .environment(\.colorScheme, .dark) // Dark Mode
}

