//
//  ConversionViewModel.swift
//  MarvelCharactersDetails
//
//  Created by Mateus Rodrigues on 24/03/22.
//

import UIKit
import RxSwift
import RxCocoa

class ConversionViewModel {
    
    let service: QuotesService
    
    let title: String
    let acronym: String?
    let placeholderConvertion: String
    let placeholderResult: String
    var escolhaUmTextButton: String
    var escolhaDoisTextButton: String
    let convertTextButton: String
    var quotes: [String : Double]
    var result: PublishSubject<String>
    
    init(acronym: String?, service: QuotesService = QuotesService()) {
        self.service = service
        self.acronym = acronym
        self.title = "Convert Moneys"
        self.placeholderConvertion = "Valor à converter"
        self.placeholderResult = "Resultado..."
        self.escolhaUmTextButton = String()
        self.escolhaDoisTextButton = String()
        self.convertTextButton = "Converter"
        self.quotes = [:]
        self.result = PublishSubject<String>()
        escolhaUmTextButton = valueUserDefault(valueToCheck: "valueOne", 1)
        escolhaDoisTextButton = valueUserDefault(valueToCheck: "valueTwo", 2)
    }
    
    func fetchQuotes() {
        service.fetchQuotes { [weak self] result in
            switch result{
            case .success(let list):
                self?.quotes = list
                print(list)
            case .failure(_):
                break
            }
        }
    }
    
    func formatValue(_ valueToFormat: Double) -> Double {
        return Double(round(1000*valueToFormat)/1000)
    }
    
    func convert(_ valueToConvert: String) {
        let acronymOne = UserDefaults.standard.string(forKey: "valueOne")
        let acronymTwo = UserDefaults.standard.string(forKey: "valueTwo")
        let value = getNumber(valueToConvert)
        
        if acronymOne == "USD" && acronymTwo != "USD" {
            quotes.forEach { quote, valueQuote in
                if quote == "USD\(acronymTwo ?? String())" {
                    print("Quote used: \(quote) - \(valueQuote)")
                    result.onNext("\(formatValue(value * valueQuote))")
                    return
                }
            }
        } else if acronymOne != "USD" && acronymTwo == "USD" {
            quotes.forEach { quote, valueQuote in
                if quote == "USD\(acronymOne ?? String())" {
                    print("Quote used: \(quote) - \(valueQuote)")
                    result.onNext("\(formatValue(value / valueQuote))")
                    return
                }
            }
        } else if acronymOne != "USD" && acronymTwo != "USD" {
            let quoteOne = quotes.filter { $0.key == "USD\(acronymOne ?? String())" }
            print("Quote used: \(quoteOne.first?.key as Any) - \(quoteOne.first?.value ?? 0.0)")
            let partialValue = value /  (quoteOne.first?.value ?? 0.0)
            let quoteTwo = quotes.filter { $0.key == "USD\(acronymTwo ?? String())" }
            print("Quote used: \(quoteTwo.first?.key as Any) - \(quoteTwo.first?.value ?? 0.0)")
            result.onNext("\(formatValue(partialValue * (quoteTwo.first?.value ?? 0.0)))")
            return
        } else {
            result.onNext("\(formatValue(value))")
        }
    }
    
    func getNumber(_ valueToConvert: String) -> Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: valueToConvert) {
            return number.doubleValue
        }
        return 0.0
    }
    
    func valueUserDefault(valueToCheck: String,_ option: Int) -> String {
        if !UserDefaults.standard.bool(forKey: "set\(valueToCheck)") {
            if let valueTwo = UserDefaults.standard.string(forKey: valueToCheck) {
                return "\(valueTwo)"
            } else {
                return "Moeda \(option)"
            }
        } else {
            UserDefaults.standard.set(acronym, forKey: valueToCheck)
            UserDefaults.standard.set(false, forKey: "set\(valueToCheck)")
            return "\(acronym ?? String())"
        }
    }
}
