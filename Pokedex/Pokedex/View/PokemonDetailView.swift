//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Image(pokemon.formattedID)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(pokemon: pokemon))
                    )
                Text(pokemon.name)
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    Text(String(format: "%.2f m", pokemon.height))
                    Text(String(format: "%.2f kg", pokemon.weight))
                }
                .font(.subheadline)
                
                HStack {
                    Text("Types")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(pokemon.types, id: \.self) { type in
                                Text(type.rawValue.capitalized)
                                    .padding()
                                    .background(Capsule().fill(Color(pokemonType: type)))
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Weaknesses")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(pokemon.weaknesses, id: \.self) { weakness in
                                Text(weakness.rawValue.capitalized)
                                    .padding()
                                    .background(Capsule().fill(Color(pokemonType: weakness)))
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(pokemon.name)
    }
}

