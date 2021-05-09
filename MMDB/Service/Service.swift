//
//  Service.swift
//  MMDB
//
//  Created by Alex kikalia on 08.05.21.
//

import Foundation

class Service {
    
    private var components = URLComponents()
    private var parameters: [String:String]
    private var apiKey : String
  
    
    init() {
        apiKey = TMDBKey
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        parameters = [:]
    }
    
    // service to fetch api, fetches two api's with one function 
    func loadMovies(for type: APIType?, page: Int,  completion: @escaping (Result<MovieList, Error>) -> ()) {
        guard let type = type else {
            completion(.failure(ServiceError.invalidParameters))
            return
        }
        components.path = "/3/movie/" + type.rawValue
        parameters = [
            "api_key" : apiKey,
            "page" : String(page)
        ]
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        if let url = components.url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
//                    print("error")
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MovieList.self, from: data)
                        completion(.success(result))
//                        print("success")
                    } catch {
//                        print("decoder failure")
                        completion(.failure(error))
                    }
                } else {
//                    print("cast failure")
                    completion(.failure(ServiceError.noData))
                }
            })
            task.resume()
        } else {
//            print ("invalid parameters")
            completion(.failure(ServiceError.invalidParameters))
        }
    }
}

enum ServiceError: Error {
    case noData
    case invalidParameters
}

enum APIType: String {
    case TopRated = "top_rated"
    case Popular = "popular"
}
