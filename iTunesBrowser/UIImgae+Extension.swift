//
//  UIImgae+Extension.swift
//  iTunesBrowser
//
//  Created by Artem Mkrtchyan on 4/11/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageFrom(_ urlString: String) {
        DispatchQueue.global().async {
            guard
                let imageUrl = URL(string: urlString),
                let imageData = try? Data(contentsOf: imageUrl) else {
                    return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: imageData)
            }
        }
    }
    
}
