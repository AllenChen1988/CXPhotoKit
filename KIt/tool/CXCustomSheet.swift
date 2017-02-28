//
//  CXCustomSheet.swift
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

protocol CXCustomSheetDelegate {
    
    func clickButton(btnTag:NSInteger,sheet:NSInteger)
}

class CXCustomSheet: UIView {

    var delegate : CXCustomSheetDelegate!
    var sheetMark : NSInteger!
    var contentView : UIView!
    
    static var allbus:[String] = NSArray() as! [String]
    

    func initWithButtons(allButtons:NSArray, tableview:Bool) -> CXCustomSheet {
        
        CXCustomSheet.allbus = allButtons as! [String]
        var startHeight:CGFloat = 0.0
        if(tableview){
            
            startHeight = 64
        }
        let sheet = CXCustomSheet.init(frame: CGRect.init(x: 0, y: startHeight, width: SCREENWIDTH, height: SCREENHEIGHT))
        sheet.set()
        return sheet
    }

    func set() {
        UIView.animate(withDuration: 0.5) { 
            self.contentView.frame = CGRect.init(x: 0, y: SCREENHEIGHT - CGFloat(44*CXCustomSheet.allbus.count) - 50, width: SCREENWIDTH, height: CGFloat(44*CXCustomSheet.allbus.count) + 50)
        }
    }

    public override init(frame: CGRect){
        super.init(frame: frame)
        let back = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
        back.backgroundColor = RGB(r: 0, g: 0, b: 0, alpha: 0.3)
        self .addSubview(back)
        
        self.contentView = UIView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: CGFloat(44*CXCustomSheet.allbus.count + 50)))
        self.addSubview(self.contentView)
        
        for i in 0 ..< CXCustomSheet.allbus.count {
            if(CXCustomSheet.allbus.count == 0){
                return
            }
            let button = UIButton.init(type: UIButtonType.custom)
            button.tag = i
            self.sheetMark = i
            button.backgroundColor = UIColor.white
            button.frame = CGRect.init(x: 0, y: CGFloat(44*i), width: SCREENWIDTH, height: 44)
            self.contentView.addSubview(button)
            button.setTitle(CXCustomSheet.allbus[i], for: UIControlState.normal)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.addTarget(self, action: #selector(clickButton(button:)), for: UIControlEvents.touchUpInside)
        
            let line = UIView.init(frame: CGRect.init(x: 0, y: 43, width: SCREENWIDTH, height: 1))
            line.backgroundColor = RGB(r: 248, g: 248, b: 248, alpha: 1)
            button.addSubview(line)
        }
        
        let button = UIButton.init(type: UIButtonType.custom)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: CGFloat(44*CXCustomSheet.allbus.count + 6), width: SCREENWIDTH, height: 44)
        button.setTitle("取消", for: UIControlState.normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.cancelButtonAction()
    }
    func clickButton(button:UIButton) {
        self.delegate.clickButton(btnTag: button.tag, sheet: self.sheetMark)
        self.removeFromSuperview()
    }
    func cancelButtonAction() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.contentView.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: CGFloat(44*CXCustomSheet.allbus.count + 50))
        }) { (true) in
            self.removeFromSuperview()
            self.delegate.clickButton(btnTag: 999, sheet: self.sheetMark)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
