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
    
    var capturedPokemon: [Pokemon] {
        pokemonList.filter { $0.captured ?? false }
    }
    
    
    func previousEvolutions(for pokemon: Pokemon) -> [Pokemon]? {
        let previousIDs = pokemon.prev_evolution ?? []
        return pokemonList.filter { previousIDs.contains($0.id) }
    }
    
    func nextEvolutions(for pokemon: Pokemon) -> [Pokemon]? {
        let nextIDs = pokemon.next_evolution ?? []
        return pokemonList.filter { nextIDs.contains($0.id) }
    }
    
    func updateCaptureStatus(for pokemon: Pokemon, captured: Bool) {
        if let index = pokedexModel.pokemonList.firstIndex(where: { $0.id == pokemon.id }) {
            pokedexModel.pokemonList[index].captured = captured
            // Notify any listeners of the update
            objectWillChange.send()
        }
    }
    
}
