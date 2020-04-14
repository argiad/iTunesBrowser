//
//  SearchResultController.swift
//  iTunesBrowser
//
//  Created by Artem Mkrtchyan on 4/11/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import UIKit
import iTunesApi


class SearchResultController: MyCollectionController {
    
    private var itemList: [iTunesItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iTunesApi.shared.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCell else  {
            return UICollectionViewCell()
        }
        cell.mainImage.image = nil
        cell.setup(item: itemList[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemList[indexPath.row]
        
        let vc = DetailController.prepare(for: item)
        self.present(vc, animated: true, completion: nil)
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    
}

extension SearchResultController: iTunesApiDelegate {
    
    func response(_ response: iTunesResponse) {
        itemList = response.results ?? []
        collectionView.reloadData()
    }
    
    func error() {
        print("Something goes wrong")
    }
  
    
    
}
