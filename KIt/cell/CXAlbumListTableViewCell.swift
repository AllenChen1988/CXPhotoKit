//
//  CXAlbumListTableViewCell.swift
//  test
//
//  Created by MyMac on 2017/2/16.
//  Copyright © 2017年 Allen. All rights reserved.
//

import UIKit

class CXAlbumListTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var last: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
