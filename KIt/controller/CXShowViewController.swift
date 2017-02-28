//
//  CXShowViewController.swift
//  test
//
//  Created by MyMac on 2017/2/16.
//  Copyright © 2017年 Allen. All rights reserved.
//
//   *f5f*               d*##$.
// zP    $e.           $"     $o
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
class CXShowViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,CXCustomSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
    var collectionView:UICollectionView!
    var imageDataSource = NSMutableArray()
    var selectArry = NSMutableArray()
    
    var collectionSuperView:UIView!
    var maxCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHCollectionList.fetchTopLevelUserCollections(with: nil)

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }

    func photoListDidClick() {
        
        if(self.selectArry.count >= self.maxCount){
        
            CXImageTool.showAlert(title: "最多选9张", message: "", controller: self, isSingle: true, complete: { (index:NSInteger) in
                
            })
        
        }
        let array = ["照相机","本地相册"]
        let sheet = CXCustomSheet().initWithButtons(allButtons: array as NSArray, tableview: false)
        sheet.delegate = self
        self.view.addSubview(sheet)
    }
    
    //MARK:- UICollectionViewDelegate & UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(self.imageDataSource.count == 0)
        {
            return 1
        }else{
            
            return self.imageDataSource.count + 1
        
        }
        
        
    }
    
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell:CXAlbumImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CXAlbumImageCollectionViewCell
        if(indexPath.row == self.imageDataSource.count){
            cell.coverImageView.image = UIImage.init(named: "plus")
            cell.closeButton.isHidden = true
        }else{
            let image = self.imageDataSource.object(at: indexPath.row)
            cell.coverImageView.image = image as? UIImage
            cell.closeButton.isHidden = false
        }
        cell.coverImageView.isUserInteractionEnabled = true
        cell.coverImageView.tag = indexPath.row
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapProfileImage(gestureRecognizer:)))
        cell.coverImageView.addGestureRecognizer(tap)
        cell.closeButton.tag = indexPath.row
        cell.closeButton.setImage(UIImage.init(named: "close"), for: UIControlState.normal)
        cell.closeButton.addTarget(self, action: #selector(closeButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    

    //MARK:- 图片cell点击事件
    func tapProfileImage(gestureRecognizer:UITapGestureRecognizer) -> Void {
        let clickImageView:UIImageView = (gestureRecognizer.view as? UIImageView)!
        
        let index:NSInteger = clickImageView.tag
        
        if(index == self.imageDataSource.count){
            self.photoListDidClick()
        }else{
            
            CXShowBigImage.sharedInstance.showBigImage(imageView: clickImageView)
        }
        
        
    }
    
//    //MARK:-  imagepicker delegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if(picker.sourceType == UIImagePickerControllerSourceType.camera){
        
            picker.dismiss(animated: true, completion: { 
                
            })
            let image = info["UIImagePickerControllerOriginalImage"] as!  UIImage
            PHPhotoLibrary.shared().performChanges({ 
              _ = PHAssetCreationRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset
                
            }, completionHandler: { (stop:Bool, error:Error?) in
                if((error) != nil){
                
                }else{
                
                    let allPhots = NSMutableArray()
                    let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
                    for i in 0...smartAlbums.count{
                        
                        let option = PHFetchOptions.init()
                        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
                        let str = NSString(format:"mediaType == %ld",PHAssetMediaType.image as! CVarArg)
                        option.predicate = NSPredicate.init(format: str as String, argumentArray: nil)
                        let collection:PHCollection = smartAlbums[i]
                        if(collection.isKind(of: PHAssetCollection.self)){
                            
                            if(collection.localizedTitle == "相机胶卷" || collection.localizedTitle == "Camera Roll"){
                                let assetCollection = PHAssetCollection()
                                let fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
                                let assets:NSArray!
                                if(fetchResult.count > 0){
                                    assets = CXImageTool.getAllPhotosAssetInAblumCollection(assetCollection: assetCollection, ascending: true)
                                    allPhots.addObjects(from: assets as! [Any])
                                }
                            }
                        
                        }
                    }
                    let PHasset = allPhots.lastObject as! PHAsset
                    
                    let item:imageModel = imageModel()
                    item.asset = PHasset
                    self.selectArry.add(item)
                    CXImageTool.getImageData(asset: item.asset, complete: { (image:UIImage, HDImage:UIImage) in
                        
                        self.imageDataSource.add(image)
                        
                        DispatchQueue.main.sync {
                            
                            picker.dismiss(animated: false, completion: { 
                                
                            })
                            self.collectionView.reloadData()
                        }
                    })
                }
                
                
            })
        }
    }
    
    func initCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 0
        let width = (SCREENWIDTH - 2 * 2) / 3
        layout.itemSize = CGSize.init(width: width, height: width)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 64, width: SCREENWIDTH, height: SCREENHEIGHT), collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        if((self.collectionSuperView) != nil){
            self.collectionSuperView.addSubview(self.collectionView)
        }else{
            self.view.addSubview(self.collectionView)
        }
        self.collectionView.register(UINib.init(nibName: "CXAlbumImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollsToBottomAnimated(animated: false)
    }
    
    func closeButtonAction(sender:UIButton) {
        
        self.selectArry.removeObject(at: sender.tag)
        self.imageDataSource.removeObject(at: sender.tag)
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了ITEM")
    }


    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,insetForSectionAtIndex section:NSInteger) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 2, 2, 2)
    }
    
    func clickButton(btnTag: NSInteger, sheet: NSInteger) {
        
        switch btnTag {
        case 0:
            let imagePaker = UIImagePickerController.init()
            imagePaker.delegate = self
            imagePaker.allowsEditing = false
            imagePaker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePaker, animated: true, completion: nil)
            break
        
        case 1:
            let vc = CXAlbumListTableViewController()
            vc.selctImageArray = self.selectArry
            vc.maxCount = self.maxCount
            let nav = UINavigationController.init(rootViewController: vc)
             weak var weakSelf: CXShowViewController?
            vc.block = {
                
                (_ array: NSMutableArray) -> Void in
                
                weakSelf?.imageDataSource.removeAllObjects()
                
                
                    for (_, value) in array.enumerated() {
                        
                        if(((value as AnyObject).asset) != nil){
                        CXImageTool.getImageData(asset: (value as AnyObject).asset, complete: { (image:UIImage, HDImage:UIImage) in
                            
                                self.imageDataSource.add(image)
                            })
                        }else{
                        
                            self.imageDataSource.add((value as AnyObject).thumbImage)
                        
                        }
                        
                            self.collectionView.reloadData()
                            self.scrollsToBottomAnimated(animated: false)
                        
                    }
                
                
            }
            
            self.present(nav, animated: true, completion: {
                
            })
            break
            
        default:
            
            break
            
        }
    }

    func scrollsToBottomAnimated(animated:Bool) -> Void {
        self.view.layoutIfNeeded()
        let offset = self.collectionView.contentSize.width - self.collectionView.bounds.width
        if(offset>0){
            self.collectionView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: animated)
        }
    }
}
