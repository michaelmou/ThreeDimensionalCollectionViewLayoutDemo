//
//  AppThumCollectionViewCell.swift
//  AppThumCollectionView
//
//  Created by MichaelMou on 15/4/9.
//  Copyright (c) 2015年 MichaelMou. All rights reserved.
//

import UIKit

class AppThumCollectionViewCell: UICollectionViewCell {

    var image:UIImage?{
        set{
            self.imageView.image = newValue
        }
        get{
            return self.imageView.image
        }
    }
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
