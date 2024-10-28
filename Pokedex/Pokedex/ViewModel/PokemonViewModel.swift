//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import Foundation

class PokemonViewModel: ObservableObject {
    @Published var pokedexModel = PokedexModel()
    
    var pokemonList: [Pokemon] {
        pokedexModel.pokemonList
    }
}
