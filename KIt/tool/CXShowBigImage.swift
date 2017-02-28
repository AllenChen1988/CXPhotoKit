//
//  CXShowBigImage.swift
//  test
//
//  Created by MyMac on 2017/2/14.
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



class CXShowBigImage: UIView,UIScrollViewDelegate {
    
    var leverlFloat:CGFloat = 0
    var verticalFloat:CGFloat = 0
    var proportionFloat:CGFloat = 0
    var imageOriginalRect:CGRect!
    var scrollerView:UIScrollView!
    var showImageView:UIImageView!
    
    
    static var sharedInstance : CXShowBigImage {
        struct Static {
            static let instance : CXShowBigImage = CXShowBigImage.init(frame: UIScreen.main.bounds)
            
        }
        Static.instance.initView()
        return Static.instance
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.initView()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //MARK:- 初始化方法
    //初始化视图
    func initView() {
        self.scrollerView = UIScrollView.init(frame: self.bounds)
        self.scrollerView.backgroundColor = RGB(r: 0, g: 0, b: 0, alpha: 0.3)
        self.scrollerView.showsVerticalScrollIndicator = false
        self.scrollerView.showsHorizontalScrollIndicator = false
        self.scrollerView.delegate = self
        self .addSubview(self.scrollerView)
         //添加按手势————单击还原关闭图片
        let oneTap = UITapGestureRecognizer.init(target: self, action: #selector(Tap(sender:)))
        self.scrollerView.addGestureRecognizer(oneTap)
        //添加按手势————双击放大缩小图片
        let twoTap = UITapGestureRecognizer.init(target: self, action: #selector(Tap(sender:)))
        twoTap.numberOfTapsRequired = 2
        self.scrollerView.addGestureRecognizer(twoTap)
        //设置优先级
        oneTap.require(toFail: twoTap)
        self.showImageView = UIImageView.init()
        self.showImageView.isUserInteractionEnabled = true
        self.scrollerView.addSubview(self.showImageView)
        
    }
    //MARK:- 手势触发
    //点击触发————单击还原关闭图片  双击放大缩小图片
    func Tap(sender:UITapGestureRecognizer)  {
        //单击----还原关闭大图
        if(sender.numberOfTapsRequired == 1){
            self.ImageReductionClose()
        //双击---放大或还原
        }else if(sender.numberOfTapsRequired == 2) {
            
            if(self.scrollerView.zoomScale > CGFloat(self.proportionFloat))
            {
                self.scrollerView.setZoomScale(CGFloat(self.proportionFloat), animated: true)
            }else{
               //双击坐标相对屏幕坐标 
                let point:CGPoint = sender.location(in: self)
                //放大图片
                self.enlargeImage(point: point)
                
            }
        
        }
    }
    /*
     *作用：放大图片
     *参数：
     *      ponint  双击点相对屏幕坐标
     */
    func enlargeImage(point:CGPoint)  {
        
        UIView.animate(withDuration: 0.4) { 
            self.scrollerView.zoomScale = self.scrollerView.maximumZoomScale
        }
        //相对边距坐标
        let APanNextPoint = CGPoint.init(x: point.x - self.leverlFloat, y: point.y - self.verticalFloat)
        //滚动视图真实偏移坐标
        var AOffsetPoint = self.scrollerView.contentOffset
        if((self.showImageView.image?.size.height)! * self.proportionFloat * self.scrollerView.maximumZoomScale > self.frame.size.height){
            let Y = APanNextPoint.y * self.scrollerView.zoomScale/self.proportionFloat - self.showImageView.center.y
            AOffsetPoint.y = AOffsetPoint.y + Y
            
            let AMaxContentHeight = self.scrollerView.contentSize.height - self.scrollerView.height
            AOffsetPoint.y = AOffsetPoint.y<AMaxContentHeight ? AOffsetPoint.y : AMaxContentHeight
            AOffsetPoint.y = AOffsetPoint.y>0 ? AOffsetPoint.y : 0
        }
        if((self.showImageView.image?.size.width)! * self.proportionFloat * self.scrollerView.maximumZoomScale > self.width){
            
            let X = APanNextPoint.x * self.scrollerView.zoomScale/self.proportionFloat - self.showImageView.center.x
            AOffsetPoint.x = AOffsetPoint.x + X
            let AMaxContentWidth = self.scrollerView.contentSize.width - self.scrollerView.width
            
            AOffsetPoint.x = AOffsetPoint.x < AMaxContentWidth ? AOffsetPoint.x : AMaxContentWidth;
            
            AOffsetPoint.x = AOffsetPoint.x > 0 ? AOffsetPoint.x : 0;
        }
        
        UIView.animate(withDuration: 0.4) { 
            self.scrollerView.contentOffset = AOffsetPoint
        }
        
        
    }
    //单击----还原关闭大图
    func ImageReductionClose() {
        UIView.animate(withDuration: 0.4, animations: {
            
            self.scrollerView.backgroundColor = UIColor.clear
            self.scrollerView.zoomScale = CGFloat(self.proportionFloat)
            
            var ARect = self.showImageView.frame
            
            ARect.origin.x = self.imageOriginalRect.origin.x - self.leverlFloat
            
            ARect.origin.y = self.imageOriginalRect.origin.y - self.verticalFloat
            
            ARect.size.width = self.imageOriginalRect.size.width
            
            ARect.size.height = self.imageOriginalRect.size.height
            
            self.showImageView.frame = ARect
            
            UIView.commitAnimations()

            
        }) { (finished:Bool) in
            
            self.showImageView.removeFromSuperview()
            self.showImageView.image = nil
            self.removeFromSuperview()
        }
    }
    //MARK:- UICollectionViewDelegate
    //告诉scrollview要缩放的是哪个子控件
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.showImageView
    }
    //缩放时调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if(scrollView.zoomScale < self.proportionFloat){
            self.showImageView.center = self.center
            var ARect = self.showImageView.frame
            ARect.origin.x = ARect.origin.x - self.leverlFloat
            ARect.origin.y = ARect.origin.y - self.verticalFloat
            self.showImageView.frame = ARect
        }else if(scrollView.zoomScale == self.proportionFloat){
            self.showImageView.center = self.center
            var ARect = self.showImageView.frame
            ARect.origin.x = 0
            ARect.origin.y = 0
            self.showImageView.frame = ARect
            
        }
        self.initMargin()
    }
    //初始化边距
    func initMargin() {
        self.leverlFloat = (self.width - (self.showImageView.image?.size.width)! * self.scrollerView.zoomScale)/2.0
        if(self.leverlFloat < 0){
            self.leverlFloat = 0
        }
        self.verticalFloat = (self.height - (self.showImageView.image?.size.height)! * self.scrollerView.zoomScale)/2.0
        if(self.verticalFloat < 0)
        {
            self.verticalFloat = 0
        }

        self.scrollerView.contentInset = UIEdgeInsetsMake(self.verticalFloat, self.leverlFloat, self.verticalFloat, self.leverlFloat)
  
    }
    //MARK:-  自定义共有方法
    //显示图片
    func showBigImage(imageView:UIImageView) -> Void {
        //添加显示视图
        let app = UIApplication.shared;
        app.keyWindow?.addSubview(self)
        //初始化图片显示视图
        self.initImageView(imageView: imageView)
        //图片适应剧中显示
        self.ImageAdaptCenter()
    }
    //MARK:- 自定义私有方法
    //初始化显示图片
    func initImageView(imageView:UIImageView)  {
        //保存图片原始框架————相对屏幕位置
//        self.initView()
        self.imageOriginalRect = imageView.bounds
        self.imageOriginalRect.origin = imageView.convert(CGPoint.init(x: 0, y: 0), to: UIApplication.shared.keyWindow)
        
        //计算缩放比例
        let AImageSize = imageView.image?.size
        self.proportionFloat = self.height/(AImageSize?.height)!
        if((AImageSize?.width)!*self.proportionFloat > self.width){
            self.proportionFloat = self.width/(AImageSize?.width)!
        }
        
        //初始化图片视图
        self.showImageView.image = imageView.image!
        self.showImageView.frame = self.imageOriginalRect
        
    }
    //图片适应居中(带动画效果)
    func ImageAdaptCenter()  {
        UIView.animate(withDuration: 0.4, animations: { 
            self.scrollerView.backgroundColor = UIColor.black
            var ARect = self.showImageView.frame
            ARect.size.width = (self.showImageView.image?.size.width)! * self.proportionFloat
            ARect.size.height = (self.showImageView.image?.size.height)! * self.proportionFloat
            self.showImageView.frame = ARect
            self.showImageView.center = self.center
        }) { (finfshed:Bool) in
            self.showImageView.frame = CGRect.init(x: 0, y: 0, width: (self.showImageView.image?.size.width)!, height: (self.showImageView.image?.size.height)!)
            
            self.initScaling()
            
            self.initMargin()
        }
    }
    
    //初始化缩放比例
    func initScaling()  {
        self.scrollerView.contentSize = (self.showImageView.image?.size)!
        self.scrollerView.minimumZoomScale = self.proportionFloat
        self.scrollerView.maximumZoomScale = self.proportionFloat * 3
        self.scrollerView.zoomScale = self.proportionFloat
    }
    
}
