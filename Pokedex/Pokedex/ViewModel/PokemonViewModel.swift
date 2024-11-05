//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import Foundation

class PokemonViewModel: ObservableObject {
    @Published var pokedexModel = PokedexModel() {
        didSet {
            saveCapturedStatus()
        }
    }
    
    private let capturedPokemonKey = "capturedPokemon"

    init() {
        //print("PokemonViewModel initialized")
        loadCapturedStatus()
    }
    
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
    
    private func saveCapturedStatus() {

        let capturedStatus = pokedexModel.pokemonList.compactMap { pokemon in
            return pokemon.captured == true ? pokemon.id : nil
        }
        //print("Saving captured Pokémon IDs: \(capturedStatus)")
        UserDefaults.standard.set(capturedStatus, forKey: capturedPokemonKey)
    }

    private func loadCapturedStatus() {

        if let capturedIDs = UserDefaults.standard.array(forKey: capturedPokemonKey) as? [Int] {
            //print("Loaded captured Pokémon IDs: \(capturedIDs)")
            for index in pokedexModel.pokemonList.indices {
                if capturedIDs.contains(pokedexModel.pokemonList[index].id) {
                    pokedexModel.pokemonList[index].captured = true
                } else {
                    pokedexModel.pokemonList[index].captured = false
                }
            }
        }
    }
    
}
