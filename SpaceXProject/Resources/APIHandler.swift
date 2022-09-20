//
//  APIHandler.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import Foundation

enum URLString {
    static let spaceXLaunches = "https://api.spacexdata.com/v3/launches"
}

protocol APIService {
    func fetchData<T: Codable>(urlString: String, completion: ((Result<T, Error>) -> Void)?)
}

class APIHandler: APIService {
    
    enum APIError: Error {
        case failedToCreateURL
        case errorFetchingData(error: String)
    }
    
    typealias Completion<T: Codable> = ((Result<T, Error>) -> Void)?
        
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData<T: Codable>(urlString: String, completion: Completion<T>) {
        
        guard let url = URL(string: urlString) else {
            completion?(.failure(APIError.failedToCreateURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?(.failure(APIError.errorFetchingData(error: String(describing: error))))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                completion?(.success(decodedData))
            }
            catch(let decodingError) {
                completion?(.failure(decodingError))
            }
        }
        task.resume()
    }
}

extension String: Error { }
