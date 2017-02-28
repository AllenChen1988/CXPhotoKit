//
//  ViewController.swift
//  CXPhotoKit
//
//  Created by MyMac on 2017/2/28.
//  Copyright © 2017年 Allen. All rights reserved.
//

import UIKit




class ViewController: UIViewController{
    
    
    
    override func viewDidLoad() {
        let button = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect.init(x: 0, y: 200, width: SCREENWIDTH, height: 200)
        button.addTarget(self, action: #selector(pushToAlbum), for: UIControlEvents.touchUpInside)
        button.setTitle("xxxxxxxxxxxx", for: UIControlState.normal)
        self.view.addSubview(button)
        button.setTitleColor(UIColor.purple, for: UIControlState.normal)
        
        
    }
    func pushToAlbum()  {
        self.navigationController?.pushViewController(CXAlbumViewController(), animated: true)
    }
}

