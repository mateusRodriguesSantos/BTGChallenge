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
    let disposeBag = DisposeBag()
    var listAcronym: [String]
    var listName: [String]
    var listCurrency: [String:String]
    var listCurrencySearch: [String:String]
    var listCurrencyRelay: BehaviorRelay<[String:String]>
    var searchedText: PublishSubject<String>
    
    init(service: CurrencieService = CurrencieService()) {
        self.service = service
        title = "Qual moeda ?"
        listAcronym = []
        listName = []
        listCurrency = [:]
        listCurrencySearch = [:]
        listCurrencyRelay = BehaviorRelay(value: listCurrency)
        searchedText = PublishSubject<String>()
        addObservableSearch()
    }
    
    func fechCurrencys() {
        service.fetchCurrencys { [weak self] result in
            switch result {
            case .success(let list):
                self?.listCurrency = list
                self?.listCurrencySearch = list
                self?.listCurrencyRelay.accept(list)
            case .failure(_):
                self?.listCurrencyRelay.accept([:])
            }
        }
    }
    
    func addObservableSearch() {
        searchedText.subscribe(onNext: { [weak self] textSearch in
            if textSearch.isEmpty {
                self?.listCurrencyRelay.accept(self?.listCurrency ?? [:])
            } else {
                var dictionarySearch: [String:String] = [:]
                self?.listCurrency.forEach({ key, value in
                    if key.contains(textSearch) || value.contains(textSearch) {
                        dictionarySearch[key] = value
                    }
                })
                self?.listCurrencyRelay.accept(dictionarySearch)
            }
        }).disposed(by: self.disposeBag)
    }
    
}
