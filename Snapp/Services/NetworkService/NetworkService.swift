//
//  NetworkService.swift
//  Snapp
//
//  Created by Максим Жуин on 16.04.2024.
//

import Foundation


protocol NetworkServiceProtocol {
    func fetchDataWith(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    func fetchDataWith(url: String, completion: @escaping (Result<Data, any Error>) -> Void) {
        let urlToFetch = URL.init(string: url)
        
    }
}
