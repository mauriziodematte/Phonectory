//
//  PStyle.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 3/11/2019.
//  Copyright © 2019 md. All rights reserved.
//

import Foundation
import UIKit

// defining available font type
enum PStyleFontWeight:Int{
    case regular
    case medium
    case bold
    case condensedBlack
    case light
    case ultraLight
    case ultraLightItalic
    case thin
}

// Custom Style class
class PStyle: NSObject {
    
    // defining base colors for application
    static let veryLightGray = UIColor.init(white: 0.95, alpha: 1)
    static let darkGray = UIColor.init(white: 0.25, alpha: 1)
    static let gray = UIColor.init(white: 0.5, alpha: 1)
    static let lightGray = UIColor.init(white: 0.75, alpha: 1)
    static let veryDarkGray = UIColor.init(white: 0.05, alpha: 1)
    
    static let lightButtonBgColor = UIColor.init(white: 1, alpha: 0.7)
    
    static let red = UIColor.init(red: 178.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1)
    static let redBgColor = UIColor.init(red: 255.0/255.0, green: 163.0/255.0, blue: 88.0/255.0, alpha: 1)
    
    // creating custom base font
    static func baseFont( size: CGFloat, weight: PStyleFontWeight) -> UIFont {
        switch weight {
        case .medium:
            return  UIFont(name: "HelveticaNeue-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        case .bold:
            return  UIFont(name: "HelveticaNeue-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        case .condensedBlack:
            return  UIFont(name: "HelveticaNeue-CondensedBlack", size: size) ?? UIFont.systemFont(ofSize: size)
        case .light:
            return  UIFont(name: "HelveticaNeue-Light", size: size) ?? UIFont.systemFont(ofSize: size)
        case .ultraLight:
            return  UIFont(name: "HelveticaNeue-UltraLight", size: size) ?? UIFont.systemFont(ofSize: size)
        case .ultraLightItalic:
            return  UIFont(name: "HelveticaNeue-UltraLightItalic", size: size) ?? UIFont.systemFont(ofSize: size)
        case .thin:
            return  UIFont(name: "HelveticaNeue-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
        default:
            return  UIFont(name: "HelveticaNeue", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    static func usableAreaMarginTop(view: UIViewController) -> CGFloat {
        var marginTop : CGFloat = 0.0
        if let navController = view.navigationController {
            marginTop += navController.navigationBar.frame.height
        }
        if #available(iOS 11.0, *) {
            let  mm = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
            marginTop += mm
        }
        return marginTop
    }
    
    static func usableAreaMarginBottom(view: UIViewController) -> CGFloat {
        var marginBottom : CGFloat = 0.0
        if let tabController = view.tabBarController {
            marginBottom += tabController.tabBar.frame.height
        }
        if #available(iOS 11.0, *) {
            marginBottom += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        }
        
        return marginBottom
    }
    
    static func usableAreaMarginHeight(view: UIViewController) -> CGFloat {
        var marginHeight =  UIScreen.main.bounds.height
        marginHeight -= PStyle.usableAreaMarginTop(view: view)
        marginHeight -= PStyle.usableAreaMarginBottom(view: view)
        
        return marginHeight
    }
    /// returns a percentage due to screen size, used to define dimensions in custom  elements
    static func screenSizeAdapter() -> CGFloat {
        if  UIScreen.main.bounds.width <= 320 {
            return 0.85
        }
        return 1
    }
    
}
