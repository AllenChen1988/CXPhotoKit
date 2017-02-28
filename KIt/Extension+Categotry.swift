//
//  Extension+Categotry.swift
//  test
//
//  Created by Allen on 2017/1/9.
//  Copyright © 2017年 CBD. All rights reserved.
//

import Foundation

import UIKit


extension String{
/** MD5 */
    func md5String() -> String{
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String  
    }
/** UILabel自适应 */
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
            textSize = self.size(attributes: attributes as? [String : Any])
        } else {
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes as? [String : Any], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
/** UILabel宽 */
    func widthForfont(font:UIFont) -> CGFloat {
        
        return self.textSizeWithFont(font: font, constrainedToSize: CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))).width
        
    }
/** UILabel高 */
    func heightForFont(font:UIFont,width:CGFloat) -> CGFloat {
        return self.textSizeWithFont(font: font, constrainedToSize: CGSize.init(width: width, height: CGFloat(MAXFLOAT))).height
    }
    
}

//MARK:- UIColor
/** RGBColor */
    func RGB(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat)->UIColor{
    
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    
}
/** 随机色 */
    func ramdomColor() ->UIColor{
    
    let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let colorRun = UIColor.init(red:red, green:green, blue:blue , alpha: 1)
    return colorRun
}

/** 16进制颜色转换 */
    func transferStringToColor(colorStr:String,alpha:CGFloat) -> UIColor {
    
    var color = UIColor.red
    var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if cStr.hasPrefix("#") {
        let index = cStr.index(after: cStr.startIndex)
        cStr = cStr.substring(from: index)
    }
    if cStr.characters.count != 6 {
        return UIColor.black
    }
    //两种不同截取字符串的方法
    let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
    let rStr = cStr.substring(with: rRange)
    
    let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
    let gStr = cStr.substring(with: gRange)
    
    let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
    let bStr = cStr.substring(from: bIndex)
    
    color = UIColor.init(colorLiteralRed: Float(changeToInt(numStr: rStr)) / 255, green: Float(changeToInt(numStr: gStr)) / 255, blue: Float(changeToInt(numStr: bStr)) / 255, alpha: Float(alpha))
    return color
}

    func changeToInt(numStr:String) -> Int {
    
    let str = numStr.uppercased()
    var sum = 0
    for i in str.utf8 {
        //0-9 从48开始
        sum = sum * 16 + Int(i) - 48
        if i >= 65 {
            //A~Z 从65开始，但初始值为10
            sum -= 7
        }
    }
    return sum
}



typealias BtnBlock = (_ btn: UIButton) -> Void;
private var UnsafeRawPointerKey = 0

extension UIButton{
    
    func touchBlock(block:BtnBlock){
        objc_setAssociatedObject(self, &UnsafeRawPointerKey, block, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(btnClick(btn:)), for: UIControlEvents.touchUpInside)
    }
    
    func btnClick(btn:UIButton) {
        let block:BtnBlock = objc_getAssociatedObject(self, &UnsafeRawPointerKey) as! BtnBlock
        block(btn)
    }
}


extension UIView{
    /** Y */
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    /** x */
    public var x: CGFloat{
        
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    /** MaxY */
    public var MaxY:CGFloat{
        get{
            
            return self.frame.origin.x + self.frame.size.width
        }
        
    }
    /** MaxX */
    public var MaxX:CGFloat{
        get{
            
            return self.frame.origin.y + self.frame.size.height
        }
        
    }
    public var height:CGFloat{
        get{
        
            return self.frame.size.height
        }
    
    }
    public var width:CGFloat{
        get{
            return self.frame.size.width
        }
    }
    /** Center */
    func initToCenter(width:CGFloat,height:CGFloat) {
        
        self.frame = CGRect.init(x: (SCREENWIDTH - width)/2.0, y: (SCREENHEIGHT - height)/2.0, width: width, height: height)
    }
    
    
    
}
