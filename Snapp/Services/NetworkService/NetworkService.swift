//
//  NetworkService.swift
//  Snapp
//
//  Created by Максим Жуин on 16.04.2024.
//

import Foundation
import UIKit


enum InternetErrors: Error {
    case pageNotFound
    case internalServerError
    case badRequest
    case errorInSaving

    var description: String {
        switch self {
        case .pageNotFound:
            return "Sorry, page not found"
        case .internalServerError:
            return "Server Error"
        case .badRequest:
            return "Bad request"
        case .errorInSaving:
            return "Error in saving to Model"
        }
    }
}

protocol INetworkService {
    func fetchImage(string: String, completion: @escaping(Result<UIImage, InternetErrors>) -> Void)
}


final class NetworkService: INetworkService {


    func fetchImage(string: String, completion: @escaping (Result<UIImage, InternetErrors>) -> Void) {
        guard let url = URL.init(string: string) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.badRequest))
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 500:
                    completion(.failure(.badRequest))
                case 502:
                    completion(.failure(.internalServerError))
                case 404:
                    completion(.failure(.pageNotFound))
                default: break
                }
            }
            if let data = data {
                guard let image = UIImage(data: data) else { return }
                completion(.success(image))
            }
        }
        .resume()
    }



}
