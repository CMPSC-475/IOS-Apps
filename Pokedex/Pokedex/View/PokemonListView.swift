//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel = PokemonViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            VStack {
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
                

                Button(action: {
                    isDarkMode.toggle() 
                }) {
                    Image(systemName: isDarkMode ? "sun.max.circle.fill" : "moon.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(isDarkMode ? .yellow : .blue)
                        .padding()
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
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
        //.environment(\.colorScheme, .dark) // Dark Mode
}

