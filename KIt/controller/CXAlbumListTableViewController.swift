//
//  CXAlbumListTableViewController.swift
//  test
//
//  Created by MyMac on 2017/2/16.
//  Copyright © 2017年 Allen. All rights reserved.
//
//                      d*##$.
// zP"""""$e.           $"    $o
//4$       '$          $"      $
//'$        '$        J$       $F
// 'b        $k       $>       $
//  $k        $r     J$       d$
//  '$         $     $"       $~
//   '$        "$   '$E       $
//    $         $L   $"      $F ...
//     $.       4B   $      $$$*"""*b
//     '$        $.  $$     $$      $F
//      "$       R$  $F     $"      $
//       $k      ?$ u*     dF      .$
//       ^$.      $$"     z$      u$$$$e
//        #$b             $E.dW@e$"    ?$
//         #$           .o$$# d$$$$c    ?F
//          $      .d$$#" . zo$>   #$r .uF
//          $L .u$*"      $&$$$k   .$$d$$F
//           $$"            ""^"$$$P"$P9$
//          JP              .o$$$$u:$P $$
//          $          ..ue$"      ""  $"
//         d$          $F              $
//         $$     ....udE             4B
//          #$    """"` $r            @$
//           ^$L        '$            $F
//             RN        4N           $
//              *$b                  d$
//               $$k                 $F
//               $$b                $F
//                 $""               $F
//                 '$                $
//                  $L               $
//                  '$               $
//                   $               $

import UIKit
import Photos
typealias okClickComplete = (_ images:NSMutableArray) -> Void;
class CXAlbumListTableViewController: UITableViewController {
    
    var maxCount = 0
    var selctImageArray:NSMutableArray!
    var Source:[PHFetchResult<AnyObject>] = []
    
    var block: okClickComplete?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "相册"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissController))
        self.tableView.rowHeight = 80
        
        self.tableView.register(UINib.init(nibName: "CXAlbumListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAlbums()
    }

    func loadAlbums() -> Void {
        if(!CXImageTool.isOpenAuthority()){
            CXImageTool.showAlert(title: "您没打开照片权限", message: "", controller: self, isSingle: false, complete: { (index:NSInteger) in
                
                if(index == 1){
                    CXImageTool.jumpToSetting()
                }else
                {
                    
                    self.dismissController()
                    
                }
                
            })
        }else{
            
            CXImageTool.getAlbumListWithAscend(isAscend: true) { (albumList:[PHFetchResult<AnyObject>]) in
                self.Source = (albumList as NSArray!) as! [PHFetchResult<AnyObject>]
                
            }
        
        }
        
      
        
    }

    
    func dismissController() {
        self.dismiss(animated: true) {
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int{
        return self.Source.count
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 1;
        }
        else
        {
            let fetchResult:PHFetchResult = self.Source[section];
            if (fetchResult.count > 0) {
                return fetchResult.count;
            }
        }
        
        return 0;

        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CXAlbumListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CXAlbumListTableViewCell
        
        var fetchResult:PHFetchResult = self.Source[indexPath.section]
        if(indexPath.section == 0){
            cell.top.text = "相机胶卷"
            cell.last.text = NSString.init(format: "%ld", fetchResult.count) as String
        }else{
            let collection:PHCollection = fetchResult[indexPath.row] as! PHCollection
            cell.top.text = collection.localizedTitle
            
            if(collection.isKind(of: PHAssetCollection.self)){
            
                let assetCollection:PHAssetCollection = collection as! PHAssetCollection
                let assetFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
                cell.last.text = NSString.init(format: "%ld", assetFetchResult.count) as String
                fetchResult = assetFetchResult  as! PHFetchResult<AnyObject>
                
            
            }
        }
        
        if(fetchResult.count > 0)
        {
            let asset = fetchResult[0]
            CXImageTool.getImage(asset: asset as! PHAsset , size: CGSize.init(width: 120, height: 120), complete: { (image:UIImage) in
                cell.albumImageView.image = image
            })
        
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var fetchResult:PHFetchResult<AnyObject>!
        if(indexPath.section == 0){
        
            fetchResult = self.Source[0]
        }else{
        
            let result:PHFetchResult = self.Source[indexPath.section]
            let collection:PHCollection = result[indexPath.row] as! PHCollection
            
            if(collection.isKind(of: PHAssetCollection.self)){
                
                let assetCollection:PHAssetCollection = collection as! PHAssetCollection
                fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
                
            }
        }
        
        let cell:CXAlbumListTableViewCell = tableView.cellForRow(at: indexPath) as! CXAlbumListTableViewCell
        let vc: CXImageCollectionViewController = CXImageCollectionViewController()
        vc.title = cell.top.text
        vc.fetchResult = fetchResult
        vc.selectArray = self.selctImageArray
         vc.block =   {
                
                (_ array: NSMutableArray) -> Void in
                
                self.block!(array)
        }

        vc.maxCount = self.maxCount
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
