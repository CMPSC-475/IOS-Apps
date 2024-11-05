//
//  PokemonRow.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/5/24.
//

import Foundation
import SwiftUI

struct PokemonRow: View {
    let viewModel: PokemonViewModel
    let title: String
    let pokemons: [Pokemon]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(pokemons) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon, viewModel: viewModel)) {
                            PokemonCardView(pokemon: pokemon)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
