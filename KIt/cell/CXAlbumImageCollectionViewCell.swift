//
//  CXAlbumImageCollectionViewCell.swift
//  test
//
//  Created by MyMac on 2017/2/16.
//  Copyright © 2017年 Allen. All rights reserved.
//

import UIKit
import Photos
class CXAlbumImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    var asset1:PHAsset!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public var asset:PHAsset{
        get{
            return asset1
        }
        set{
            
            self.asset1 = newValue
        }
    }
    
}
