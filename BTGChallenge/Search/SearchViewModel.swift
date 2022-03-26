//
//  SearchViewModel.swift
//  BTGChallenge
//
//  Created by Mateus Rodrigues on 25/03/22.
//

import UIKit
import RxSwift
import RxRelay

class SearchViewModel {
    
    let title: String
    let service: CurrencieService
    var listAcronym: [String]
    var listName: [String]
    var listCurrency: [String:String]
    var listCurrencyRelay: BehaviorRelay<[String:String]>
    
    init(service: CurrencieService = CurrencieService()) {
        self.service = service
        title = "Qual moeda ?"
        listAcronym = []
        listName = []
        listCurrency = [:]
        listCurrencyRelay = BehaviorRelay(value: listCurrency)
    }
    
    func fechCurrencys() {
        service.fetchCurrencys { [weak self] result in
            switch result {
            case .success(let list):
                self?.listCurrencyRelay.accept(list)
            case .failure(_):
                self?.listCurrencyRelay.accept([:])
            }
        }
    }
    
}
