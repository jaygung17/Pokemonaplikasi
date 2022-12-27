//
//  PokemonLoader.swift
//  Pokemon App
//
//  Created by Novan Agung Waskito on 12/11/22.
//

import Foundation

enum PokemonResult {
    case Success ([PokemonCards])
    case failure (String)
}

class PokemonLoader {
    //call API pokemonCards
    func getPokemonCardData (completion: @escaping (PokemonResult) -> Void) {
        let url = URL(string: "https://api.pokemontcg.io/v2/cards?pageSize=10")!
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard let data = data else { return }
            DispatchQueue.main.async {
                do {
                    let pokemoncards = try self.transformJsonDataToCardList(with:data)
                    completion (.Success(pokemoncards))
                } catch let error {
                    let errorMessage = error.localizedDescription
                    completion (.failure(errorMessage))
                }
            }
        }.resume()
    }
    
    func transformJsonDataToCardList(with data: Data) throws -> [PokemonCards]  {
        let decoder = JSONDecoder()
        let cardLists = try decoder.decode(PokemonCardList.self, from: data)
        let pokemonLists = cardLists.data.map { remotePokemon in
            return map(remotePokemon: remotePokemon)
        }
        return pokemonLists
        
        func map(remotePokemon: RemotePokemonCard) -> PokemonCards {
            return PokemonCards(id: remotePokemon.id, imageURL: remotePokemon.images.large)
        }
    }
}
