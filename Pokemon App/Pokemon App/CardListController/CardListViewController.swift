//
//  CardListController.swift
//  Pokemon App
//
//  Created by Novan Agung Waskito on 12/11/22.
//

import Foundation
import UIKit

class CardListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var listCard: [PokemonCards] = [] {
        didSet {
            self.cardListCollectionView.reloadData()
        }
    }
    var pokemonType: [PokemonCards] = [] {
        didSet {
            self.categorytypeCollectionView.reloadData()
        }
    }
    var categoryTypes : [String] = []
    var selectedType : String = " "
    
    var loader = PokemonLoader()
    @IBOutlet var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var cardListCollectionView: UICollectionView!
   
    @IBOutlet weak var categorytypeCollectionView: CategoryTypeCollectionView!
    
    
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var pokemonCardReloadButton: UIButton!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSearchBar()
        setUpCardListCollectionView()
        getPokemonCardData()
        setUpPokemonTypeCollectionView()
        loadPokemonType()
        
        
    }
    //showErroLabel Method
    func showErrorLabel(with message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
    @objc
    func refresh() {
        listCard.removeAll()
        getPokemonCardData()
    }
    func startRefreshing() {
        refreshControl.beginRefreshing()
    }
    func stopRefreshing() {
        refreshControl.endRefreshing()
    }
//MARK: CollectionView for Card List

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cardListCollectionView {
            return listCard.count
        }
        return categoryTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cardListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XibPokemonCard", for: indexPath) as! CardCollectionViewCell
            let cards = listCard[indexPath.row]
            cell.downloadPokemonCardImage(for: URL(string: "\(cards.imageURL)")!)
            return cell
        } else  {
            let category = categoryTypes[indexPath.row]
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryTypeCollectionViewCell", for:indexPath) as! CategoryTypeCollectionViewCell
                    print(category)
                    cell.settingTypeButton(text: category, selected: category == selectedType)
                    return cell
        }
        
    }
    
    
//MARK: UISearchBar
    func settingSearchBar () {
        let whiteColor = UIColor.white.withAlphaComponent(0.6)
        pokemonSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: whiteColor])
        pokemonSearchBar.searchTextField.textColor = .white
        let image = UIImage(systemName: "magnifyingglass")?.withTintColor(whiteColor, renderingMode: .alwaysOriginal)
        UISearchBar.appearance().setImage(image, for: .search, state: .normal)
        navigationItem.titleView = pokemonSearchBar
    }

}
//MARK: Networking
extension CardListViewController {
    func getPokemonCardData() {
        startRefreshing()
        loader.getPokemonCardData { result in
           
            switch result {
            case .Success (let pokemonCards):
                self.listCard = pokemonCards.shuffled()
                //self.bindData (with: pokemonCards)
            case .failure (let error):
                self.showErrorLabel(with: error)
            }
            self.stopRefreshing()
        }
    }
    //bindData Method
    func bindData (with pokemonCards: [PokemonCards]) {
        DispatchQueue.main.async {
            
        }
    }
    //setUPCardListCollectionView
    func setUpCardListCollectionView() {
        cardListCollectionView.delegate = self
        cardListCollectionView.dataSource = self
        //Register XIB dengan CardCollectionViewCell dan identifier XibPokemonCard
        self.cardListCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "XibPokemonCard")
        cardListCollectionView.refreshControl = refreshControl
    }
    //setUpPokemonTypeCollectionView
    func setUpPokemonTypeCollectionView() {
        
        self.categorytypeCollectionView.delegate = self
        self.categorytypeCollectionView.dataSource = self
        //Register XIB dengan CategoryTypeCollectionViewCell dan identifier XibPokemonType
        self.categorytypeCollectionView.register(UINib(nibName: "CategoryTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "XibPokemonType")
        self.categorytypeCollectionView.refreshControl = refreshControl
    }
    //MARK: CategoryOfPokemonType
    private func loadPokemonType() {
        let loader = CategoryTypeLoader()
        startLoadPokemonType()
        loader.getPokemonTypeData { result in
            switch result {
            case .success(let CategoryTypeResult):
                self.categoryTypes = CategoryTypeResult
                DispatchQueue.main.async {
                    self.categorytypeCollectionView.reloadData()
                }
            case .failure(let err):
                self.failedToLoad(with: err.localizedDescription)
            }
        }
    }
    private func startLoadPokemonType() {
        DispatchQueue.main.async {
            self.errorMessageLabel.isHidden = true
            self.pokemonCardReloadButton.isHidden = true
        }
    }
    private func successLoadCategories(with pokemonTypeResult: [String]) {
        DispatchQueue.main.async {
            self.errorMessageLabel.isHidden = true
            self.pokemonCardReloadButton.isHidden = true
            self.categorytypeCollectionView.categoryTypes = pokemonTypeResult
            self.categorytypeCollectionView.selectedType = pokemonTypeResult.count > 0 ?pokemonTypeResult.first! : " "
            self.categorytypeCollectionView.reloadData()
        }
    }
    private func failedToLoad(with err: String) {
        self.errorMessageLabel.isHidden = false
        self.pokemonCardReloadButton.isHidden = false
    }
    

}


