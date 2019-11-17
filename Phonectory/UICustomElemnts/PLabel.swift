//
//  PLabel.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 08/11/2019.
//  Copyright © 2019 DM. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

/// custom labe with predifinedinsets , fonts and colors
class PLabel: UILabel{
    var labelFont = PStyle.baseFont(size: 16, weight: .light) {
        didSet{ innerInit() }
    }
    var padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        innerInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        innerInit()
    }
    
    private func innerInit() {
        font = UIFont(name: labelFont.fontName, size: labelFont.pointSize * PStyle.screenSizeAdapter())
        textColor = PStyle.darkGray
       
    }
}

/// label used in the new/edit form, has a validate state
class PLabelWithAlert: PLabel{
    var alertText = ""
    
    var titleText = "" {
        didSet{ drawMe() }
    }
    // staye of falidation, true means is not valid
    var isAlerting = false {
        didSet{ drawMe()  }
        
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        innerInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        innerInit()
    }
    // custom init
    private func innerInit() {
        self.padding = UIEdgeInsets(top: 2, left: 8, bottom: 54, right: 8)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        labelFont = PStyle.baseFont(size: 16, weight: .regular)
        drawMe()
    }
    // custom UI redraw of the label
    private func drawMe() {
        self.backgroundColor = UIColor.clear
        self.text = titleText
        // if field is not valid we modify the label
        if self.isAlerting {
            self.font = UIFont(name: labelFont.fontName, size: labelFont.pointSize * PStyle.screenSizeAdapter())
            self.text = alertText
            self.backgroundColor = PStyle.redBgColor
        }
        
    }
    
}
