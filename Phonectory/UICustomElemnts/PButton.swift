//
//  PButton.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 08/11/2019.
//  Copyright © 2019 DM. All rights reserved.
//
import Foundation
import UIKit
/// Custum rounded button white txt on gray with brief custom animation on press 
class PButton: UIButton {
    // set properties
    let buttonRadius = CGFloat(12)
    let buttonFont = PStyle.baseFont(size:32, weight: .ultraLight)
    let isPressed = false
    
    var buttonColor = PStyle.darkGray {
        didSet{ innerInit() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        innerInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        innerInit()
    }
    /// custom init
    private func innerInit() {
        // define font, colors and corners
        layer.cornerRadius = buttonRadius
        titleLabel?.font = buttonFont
        
        if  UIScreen.main.bounds.width <= 320 {
            titleLabel?.font = UIFont(name: buttonFont.fontName, size: buttonFont.pointSize * 0.85)
        }
        backgroundColor = buttonColor
        setTitleColor(buttonColor == PStyle.lightButtonBgColor ? PStyle.veryDarkGray : PStyle.veryLightGray, for: .normal)
        self.addTarget(self, action: #selector(pressed), for: .touchDown)
        self.addTarget(self, action: #selector(released), for: .touchCancel)
        self.addTarget(self, action: #selector(released), for: .touchUpInside)
        self.addTarget(self, action: #selector(released), for: .touchUpOutside)
        
    }
    
    @objc func pressed() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = PStyle.redBgColor
            
        })
    }
    @objc func released() {
        
        UIView.animate(withDuration: 0.45, animations: {
            self.backgroundColor = self.buttonColor
        })
    }
}
/// pButton with lightButtonbg
class PButtonWhite: PButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonColor = PStyle.lightButtonBgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonColor = PStyle.lightButtonBgColor
    }
}

// red Pbutton
class PButtonRed: PButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonColor = PStyle.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonColor = PStyle.red
    }
}
