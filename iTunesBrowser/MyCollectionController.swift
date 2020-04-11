//
//  UICollectionViewController+Exctension.swift
//  iTunesBrowser
//
//  Created by Artem Mkrtchyan on 4/11/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import UIKit

class MyCollectionController: UICollectionViewController {
    
    open var margin: CGFloat = 10
    open var numberOfCellsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confCollectionView()
    }
    
    func confCollectionView(){
        let itemCell = UINib(nibName: "ItemCell", bundle: nil)
        collectionView.register(itemCell, forCellWithReuseIdentifier: "itemCell")
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        
        let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
        let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow)*horizontalSpacing)/numberOfCellsPerRow
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth + 40.0 )
        
    }
}
