//
//  ItemCell.swift
//  iTunesBrowser
//
//  Created by Artem Mkrtchyan on 4/11/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import UIKit
import iTunesApi

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var firstLine: UILabel!
    @IBOutlet weak var secondLine: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func setup(item: iTunesItem){
        
        self.firstLine.text = item.artistName
        self.secondLine.text = item.trackName
        self.favImage.image = BusinessLogic.shared.isInFav(item) ? UIImage(systemName: "heart.fill") :  UIImage(systemName: "heart")
        
        if let urlString = item.artworkUrl100   {
            mainImage.loadImageFrom(urlString)
        }
        
    }
}
