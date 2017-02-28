//
//  CXImageTool.swift
//  test
//
//  Created by MyMac on 2017/2/9.
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

enum AlbumType {
    case  AlbumTypeDefault, AlbumTypeCumstom
}

class imageModel: NSObject {

    var thumbImage:UIImage!
    
    var asset:PHAsset!

    
    
}

class CXImageTool: NSObject {

    //MARK:- 获取相册列表
    class func getAlbumListWithAscend(isAscend:Bool,complete:@escaping (([PHFetchResult<AnyObject>]) -> Void)) {
        
       let imageOptions = PHFetchOptions.init()
        imageOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: isAscend)]
        let allphotos:PHFetchResult  = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: imageOptions)
        
        let customOptions = PHFetchOptions.init()
        customOptions.predicate = NSPredicate.init(format: "estimatedAssetCount > 0", argumentArray: nil)
        customOptions.sortDescriptors = [NSSortDescriptor.init(key: "startDate", ascending: isAscend)]
        let customPhotos = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: customOptions)
        
        let list = [allphotos,customPhotos]
        
       complete(list as! [PHFetchResult<AnyObject>])
        
    }
    //MARK:-  获取置顶大小的图片
    class func getImage(asset:PHAsset,size:CGSize,complete:@escaping ((UIImage)->Void)) {
        
        let imageManager = PHImageManager.default()
        imageManager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil) { (image:UIImage?, info:[AnyHashable : Any]?) in
            
            DispatchQueue.global().sync() {
                

                
                if(image == nil)
                {
                
                }else{

                    complete(image!)
                }


                
            }

        }
        
    }

    class func getImageData(asset:PHAsset,complete:@escaping (UIImage,UIImage) -> Void) {
        
        let option = PHImageRequestOptions.init()
        option.isSynchronous = true
        let imageManager = PHImageManager.default()
        imageManager.requestImageData(for: asset, options: option) { (imageData:Data?, dataUTI:String?, orientation:UIImageOrientation,info: [AnyHashable : Any]?) in
            let HDImage = UIImage.init(data: imageData!)
            let image = HDImage
            complete(image!,HDImage!)
        }
    }

    //MARK:- 获取相册里的所有图片的PHAsset对象
    class func getAllPhotosAssetInAblumCollection(assetCollection:PHAssetCollection,ascending:Bool) -> NSArray {
        //存放所有图片对象
        let assets = NSMutableArray.init();
        
        //是否按时间排序
        let option = PHFetchOptions.init();
        let str = NSString(format:"mediaType == %ld",PHAssetMediaType.image as! CVarArg)
        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: ascending)]
        option.predicate = NSPredicate.init(format: str as String, argumentArray: nil)
        
        let result = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: option)
        //遍历
        result.enumerateObjects({ (asset:PHAsset, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) in
            assets.add(asset)
        })
        
        
        return assets
    }
  
    class func isOpenAuthority() -> Bool {
        return PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.denied
    }
    
   class func jumpToSetting() -> Void {
        let app = UIApplication.shared;
        app.open(NSURL.init(string: UIApplicationOpenSettingsURLString) as! URL)
    }

    class func showAlert(title:NSString,message:NSString,controller:UIViewController,isSingle:Bool,complete:@escaping(NSInteger) ->Void ) -> Void {
        let alertController = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) in
            complete(0)
        }
        let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            complete(1)
        }
        
        if !isSingle {
            alertController.addAction(cancleAction)
        }
        alertController.addAction(confirmAction)
        
        controller.present(alertController, animated: true, completion: nil)
        
    }


    
}
