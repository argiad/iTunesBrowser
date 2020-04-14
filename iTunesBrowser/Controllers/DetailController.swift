//
//  DetailController.swift
//  iTunesBrowser
//
//  Created by Artem Mkrtchyan on 4/11/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import UIKit
import iTunesApi

class DetailController: UIViewController {
    
    private var bl = BusinessLogic.shared
    
    var item: iTunesItem? = nil
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var firstLine: UILabel!
    @IBOutlet weak var secondLine: UILabel!
    @IBOutlet weak var addToFavorite: UIButton!
    
    @IBAction func like(_ sender: Any) {
        if let item = self.item{
            bl.setFavState(!bl.isInFav(item), item: item)
            setFavImage()
        }
    }
    
    @IBAction func open(_ sender: Any) {
        
        guard let urlString = item?.trackViewURL,
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        if let item = self.item {
            
            self.firstLine.text = item.artistName
            self.secondLine.text = item.trackName
            
            if let urlString = item.artworkUrl100   {
                mainImage.loadImageFrom(urlString)
            }
            
        }
        
        setFavImage()
    }
    
    private func setFavImage() {
        if let item = self.item {
            let image = bl.isInFav(item) ? UIImage(systemName: "heart.fill") :  UIImage(systemName: "heart")
            addToFavorite.setImage(image, for: .normal)
        }
    }
    
    class func prepare(for item: iTunesItem) -> UIViewController {
        let storyBoard =  UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "DetailController")
        
        if let vc = viewController as? DetailController {
            vc.item = item
        }
        
        return viewController
    }
    
    
    
}
