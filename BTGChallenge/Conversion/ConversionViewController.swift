//
//  ViewController.swift
//  BTGChallenge
//
//  Created by Mateus Rodrigues on 25/03/22.
//

import UIKit

class ConversionViewController: UIViewController {

    var viewModel: ConversionViewModel

    init(acronym: String) {
        viewModel = ConversionViewModel(acronym: acronym)
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        viewModel = ConversionViewModel(acronym: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchQuotes()
    }
    override func loadView() {
        super.loadView()
        let viewConversion = ConversionView(viewModel: self.viewModel)
        viewConversion.delegate = self
        self.view = viewConversion
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

extension ConversionViewController: ConversionDelegate {

    func buttonConvertClicked(valueToConvert: String) {
        viewModel.convert(valueToConvert)
    }
    
    func buttonChoiceCurrencyOneClicked() {
        UserDefaults.standard.set(true, forKey: "setvalueOne")
        PeformNavigation.navigate(event: ConversionCoordinatorDestinys.search)
    }
    
    func buttonChoiceCurrencyTwoClicked() {
        UserDefaults.standard.set(true, forKey: "setvalueTwo")
        PeformNavigation.navigate(event: ConversionCoordinatorDestinys.search)
    }
    
}

