//
//  PokemonApi.swift
//  asyncawait-example
//
//  Created by Pedro Somensi on 19/02/24.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case offline
    case custom(String)
}

struct Pokemon: Codable {
    let name: String
}

final class PokemonApi {
    
    private static let endpoint = "https://pokeapi.co/api/v2/pokemon/charizard"
    
    private func makeURLRequest() -> URLRequest? {
        guard let url = URL(string: PokemonApi.endpoint) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    func getCharizard(completion: @escaping (Result<Pokemon, APIError>) -> Void) {
        guard let urlRequest = makeURLRequest() else {
            return completion(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            let result: Result<Pokemon, APIError>
            
            defer {
                completion(result)
            }
            
            guard error == nil else {
                result = .failure(.custom(error!.localizedDescription))
                return
            }
            
            guard let data = data else {
                result = .failure(.custom("no data"))
                return
            }
            
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                result = .success(pokemon)
                return
            } catch {
                result = .failure(.custom(error.localizedDescription))
                return
            }

        }.resume()
        
    }
    
    func getCharizard() async throws -> Pokemon {
        return try await withCheckedThrowingContinuation { continuation in
            getCharizard { result in
                continuation.resume(with: result)
            }
        }
    }
    
    
}
