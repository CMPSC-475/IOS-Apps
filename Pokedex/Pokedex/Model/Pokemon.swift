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
    
    var formattedID: String {
        String(format: "%03d", id)
    }
}

class PokedexModel {
    var pokemonList: [Pokemon] = []
    
    init() {
        loadPokemonData()
    }
    
    private func loadPokemonData() {
        if let url = Bundle.main.url(forResource: "pokedex", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let decodedData = try? decoder.decode([Pokemon].self, from: data) {
                pokemonList = decodedData
            }
        }
    }
}

