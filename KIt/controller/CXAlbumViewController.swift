//
//  albumViewController.swift
//  test
//
//  Created by MyMac on 2017/2/8.
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


class CXAlbumViewController: CXShowViewController{

    var imageCollectionView:UIView!
    
    override func viewDidLoad() {
       
        // 1. 新建一个类继承 MLShowViewController
        
        // 2. 设置collectionSuperView进行赋值
        self.collectionSuperView = self.imageCollectionView;
        // 3. 设置可添加图片的最大数
        self.maxCount = 9;
        // 4. 初始化CollectionView
        self.initCollectionView()
        
    }
}
