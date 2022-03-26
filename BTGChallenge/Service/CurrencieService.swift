//
//  BTGService.swift
//  BTGChallenge
//
//  Created by Mateus Rodrigues on 24/03/22.
//

import NetworkCore

protocol CurrencieProtocol: NetworkProtocol where T == Currencies {
    func fetchCurrencys(completion: @escaping (Result<[String : String], ErrorsRequests>) -> Void)
}

class CurrencieService: CurrencieProtocol {
    
    func fetchCurrencys(completion: @escaping (Result<[String : String], ErrorsRequests>) -> Void) {
        execute(
            connection: ConnectionList()
        ) { result in
            switch result {
            case .success(let list):
                if let listCurrencies = list?.currencies {
                    completion(.success(listCurrencies))
                } else {
                    completion(.failure(.errorDecode))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
