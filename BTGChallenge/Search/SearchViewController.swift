//
//  SearchViewController.swift
//  BTGChallenge
//
//  Created by Mateus Rodrigues on 25/03/22.
//

import UIKit

class SearchViewController: UIViewController {

    let viewModel = SearchViewModel()

    override func loadView() {
        super.loadView()
        let viewSearch = SearchView(viewModel: self.viewModel)
        viewSearch.delegate = self
        self.view = viewSearch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fechCurrencys()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension SearchViewController: SearchDelegate {
    func currencieSelectedClicked(_ cell: CurrencyCellView) {
        guard let acronym = cell.acronym else { return }
        PeformNavigation.navigate(event: SearchCoordinatorDestinys.backToConversion(acronym: acronym))
    }
}

