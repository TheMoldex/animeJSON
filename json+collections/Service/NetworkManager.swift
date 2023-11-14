//
//  Networking.swift
//  json+collections
//
//  Created by Денис Сташков on 14.11.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    let imageURL = URL(string: "https://cdn.pixabay.com/photo/2012/03/01/01/42/hands-20333_960_720.jpg")!
    let animeLink = URL(string: "https://animechan.xyz/api/random")!
    
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { 
                completion(.failure(.noData))
                return }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetchRandomAnimeQuote(from url: URL, completion: @escaping (Result<Anime, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let randomAnime = try decoder.decode(Anime.self, from: data)
                completion(.success(randomAnime))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }
}
