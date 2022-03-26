//
//  QuotesService.swift
//  BTGChallenge
//
//  Created by Mateus Rodrigues on 24/03/22.
//

import NetworkCore

protocol QuotesProtocol: NetworkProtocol where T == Quotes {
    func fetchQuotes(completion: @escaping (Result<[String:Double], ErrorsRequests>) -> Void)
}

class QuotesService: QuotesProtocol {

    func fetchQuotes(completion: @escaping (Result<[String:Double], ErrorsRequests>) -> Void) {
        execute(
            connection: ConnectionLive()
        ) { result in
            switch result {
            case .success(let list):
                if let listQuotes = list?.quotes {
                    completion(.success(listQuotes))
                } else {
                    completion(.failure(.errorDecode))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
