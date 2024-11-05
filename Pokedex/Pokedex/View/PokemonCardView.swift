//
//  PokemonCardView.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/5/24.
//

import Foundation
import SwiftUI

struct PokemonCardView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            Image(pokemon.formattedID)
                .resizable()
                .frame(width: 80, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(pokemon: pokemon))
                )
                .overlay(
                    // Only show the checkmark if the Pokémon is captured
                    Group {
                        if pokemon.captured ?? false {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .padding([.top, .trailing], 5)
                        }
                    },
                    alignment: .topTrailing
                )
            Text(pokemon.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: 100)
    }
}


