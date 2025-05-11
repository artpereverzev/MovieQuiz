//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Artem Pereverzev on 11.05.2025.
//
import Foundation

struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Checking if got response error
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Checking if response is succes, else write failure error
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Return data
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
