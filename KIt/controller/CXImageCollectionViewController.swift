//
//  CXImageCollectionViewController.swift
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

typealias OkClickComplete = (_ images:NSMutableArray) -> Void

class CXImageCollectionViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var collectionView:UICollectionView!
    
    var dataCount = 0
    
    var fetchResult:PHFetchResult<AnyObject>!
  
    var maxCount = 0
    
    var selectArray = NSMutableArray()
    
    var block: OkClickComplete?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataCount = self.selectArray.count
    
        
        self.creatCollectionView()
        self.changeRightBarButtonItemTitle()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelNacigationItemAction))
    }
    func cancelNacigationItemAction() {
        let count = self.selectArray.count
        for _ in self.dataCount...count{
            self.selectArray.removeLastObject()
        }
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    func tapProfileImage(gestureRecognizer:UITapGestureRecognizer) -> Void {
        
        let clickImageView = gestureRecognizer.view as! UIImageView
        let index = clickImageView.tag
        if(index == self.fetchResult.count){
        self.coverImageViewWithCamera()
            
        }else{
            CXShowBigImage.sharedInstance.showBigImage(imageView: clickImageView)
        }
    }
    func coverImageViewWithCamera() {
        if(self.selectArray.count >= self.maxCount){
            CXImageTool.showAlert(title: "最多只能选择9张图片", message: "", controller: self, isSingle: true, complete: { (index:NSInteger) in
            })
            return
        }
        
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker, animated: true) {
        }
        
    }
    //MARK:- imagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { 
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if(picker.sourceType == UIImagePickerControllerSourceType.camera){
            picker.dismiss(animated: true, completion: {
            })
            
            let image:UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
            
            PHPhotoLibrary.shared().performChanges({ 
                
                _ = PHAssetCreationRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset
                
            }, completionHandler: { (stop:Bool, error:Error?) in
                if(error != nil){
                
                }else{
                    let allPhots = NSMutableArray.init()
                    let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
                    for i in 0...smartAlbums.count{
                    
                        let option = PHFetchOptions.init()
                        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
                        let str = NSString(format:"mediaType == %ld",PHAssetMediaType.image as! CVarArg)
                        option.predicate = NSPredicate.init(format: str as String, argumentArray: nil)
                        let collection = smartAlbums[i]
                        
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
                    self.selectArray.add(item)
                   picker.dismiss(animated: false, completion: { 
                    
                   })
                    self.didClickNavigationBarViewRightButton()
                    
                }
            })
            
        }
    }
    func closeButtonAction(sender:UIButton) -> Void {
        let indexPath:IndexPath = NSIndexPath.init(row: sender.tag, section: 0) as IndexPath
        let cell:CXAlbumImageCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! CXAlbumImageCollectionViewCell
        
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            if(selectArray.count >= self.maxCount){
                
                CXImageTool.showAlert(title: NSString.init(format: "最多只能选择%d张图片", 9), message: "", controller: self, isSingle: true, complete: { (index:NSInteger) in
                    
                })
                return
            }
        
           sender.setImage(UIImage.init(named: "ico_check_select"), for: UIControlState.normal)
            
            let item = imageModel()
            item.asset = cell.asset
            self.selectArray.add(item)
        }else{
        
            sender.setImage(UIImage.init(named: "ico_check_nomal"), for: UIControlState.normal)
            
            var count = -1
            
            for subItem in self.selectArray{
            
                count += 1
                
                if (subItem as AnyObject).asset.localIdentifier == cell.asset.localIdentifier {
                    self.selectArray.removeObject(at: count)
                    break
                }
                
            }
        }
        self.changeRightBarButtonItemTitle()
    }


    func didClickNavigationBarViewRightButton() {
         if (self.selectArray.count > 0) {
            
                self.block!(self.selectArray)
            
        }
            self.navigationController?.dismiss(animated: true, completion: {
                
            })
        
    }
    func changeRightBarButtonItemTitle() {
        if(self.selectArray.count > 0){
            let title = NSString.init(format: "确定(%ld)", self.selectArray.count)
            self.setRightBarButtonItem(title: title)
        }else{
        
            self.setRightBarButtonItem(title: "取消")
        }
    }

    func setRightBarButtonItem(title:NSString) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title as String, style: UIBarButtonItemStyle.plain, target: self, action: #selector(didClickNavigationBarViewRightButton))
    }

    func scrollsToBottomAnimated(animated:Bool) {
        self.view.layoutIfNeeded()
        let offset = self.collectionView.contentSize.height - self.collectionView.height
        if(offset > 0)
        {
            let width = (SCREENWIDTH - 2*2)/3
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: offset + width/2.0), animated: animated)
        }
    }

    func creatCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 2.0
        layout.minimumLineSpacing = 2.0
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        let  width:CGFloat = (SCREENWIDTH - 2 * 2) / 3
        layout.itemSize = CGSize.init(width: width, height: width)
        
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT), collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(UINib.init(nibName: "CXAlbumImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
//        self.scrollsToBottomAnimated(animated: false)
    }
    //MARK:-  UICollectionViewDelegate & UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CXAlbumImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CXAlbumImageCollectionViewCell
        cell.coverImageView.clipsToBounds = true
        cell.coverImageView.contentMode = UIViewContentMode.scaleToFill
        
        if(indexPath.row == self.fetchResult.count){
            
            cell.coverImageView.image = UIImage.init(named: "plus")
            cell.closeButton.isHidden = true
            
        }else{
        
            cell.closeButton.isHidden = false
            let asset:PHAsset = self.fetchResult[indexPath.row] as! PHAsset
            if(!((objc_getAssociatedObject(self, "PHAssetThumbImageKey") != nil))){
            
                CXImageTool.getImage(asset: asset, size: CGSize.init(width: kItemWidth, height: kItemWidth), complete: { (image:UIImage) in
                    cell.coverImageView.image = image
                })
            
            }else{
                cell.coverImageView.image = objc_getAssociatedObject(self, "PHAssetThumbImageKey") as! UIImage?
            }
            cell.asset = asset
            cell.closeButton.tag = indexPath.row
            cell.closeButton.setImage(UIImage.init(named: "ico_check_nomal"), for: UIControlState.normal)
            cell.closeButton.addTarget(self, action: #selector(closeButtonAction(sender:)), for: UIControlEvents.touchUpInside)
         
            for item in self.selectArray{
            
                if((item as AnyObject).asset.localIdentifier == asset.localIdentifier){
                
                    cell.closeButton.isSelected = true
                    cell.closeButton.setImage(UIImage.init(named: "ico_check_select"), for: UIControlState.normal)
                }
            }
            
        }
        cell.coverImageView.isUserInteractionEnabled = true
        cell.coverImageView.tag = indexPath.row
        cell.coverImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapProfileImage(gestureRecognizer:))))
        return cell
    }
    

    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
