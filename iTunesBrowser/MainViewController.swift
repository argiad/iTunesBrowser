//
//  MainViewController.swift
//  iTunesBrowser
//
//  Created by Artem Mkrtchyan on 4/11/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import UIKit
import iTunesApi

class MainViewController: MyCollectionController {
    
    private var searchController: UISearchController!
    private var selectedItem = 0
    private let buttons = [MediaType.all,
                  MediaType.music,
                  MediaType.musicVideo,
                  MediaType.movie]
    
    private var favList: [iTunesItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confSearchController()
        
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favListReload()
    }
    
    
    private func favListReload() {
        favList = BusinessLogic.shared.fetchItems()
        collectionView.reloadData()
    }
    
    private func confSearchController() {
        
        guard let searchResultController = storyboard?.instantiateViewController(identifier: "SearchResultController") as? SearchResultController else {
            return
        }
        
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = buttons.compactMap({ $0.name })
        
        navigationItem.searchController = searchController
    }
}

extension MainViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        favListReload()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedItem = selectedScope
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
             searchString.count >= 3 else {
                 return
         }

        guard let apiRequest = iTunesSearchRequest(term: searchString, mediaType: buttons[selectedItem], limit: 50) else {
             return
         }
        
        iTunesApi.shared.search(by: apiRequest)
    }
    
    
}

extension MainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCell else  {
            return UICollectionViewCell()
        }
        
        cell.setup(item: favList[indexPath.row])
        cell.favImage.image = UIImage(systemName: "heart.fill")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = favList[indexPath.section]
        
        let vc = DetailController.prepare(for: item)
        self.present(vc, animated: true, completion: nil)
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}
