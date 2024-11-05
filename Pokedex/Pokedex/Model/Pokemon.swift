//
//  Pokemon.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import Foundation

struct Pokemon: Identifiable, Decodable {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let types: [PokemonType]
    let weaknesses: [PokemonType]
    var captured: Bool? // Default to false
    let prev_evolution: [Int]?
    let next_evolution: [Int]?
    
    var formattedID: String {
        String(format: "%03d", id)
    }
}

class PokedexModel {
    @Published var pokemonList: [Pokemon] = []
    
    init() {
        loadPokemons()

    }
    
    private func loadPokemons() {
        if let url = Bundle.main.url(forResource: "pokedex", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.pokemonList = try decoder.decode([Pokemon].self, from: data)

            } catch {

            }
        } else {

        }
    }
}

