//
//  PContactTableViewCell.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 08/11/2019.
//  Copyright © 2019 DM. All rights reserved.
//

import UIKit
import Foundation

/// Table view cell for list of contacts
class PContactTableViewCell: UITableViewCell {
    
    var lastnameValue = ""
    var name = "" {
        didSet{ drawMe() }
    }
    var lastname = "" {
        didSet{ drawMe() }
    }
    var number = "" {
        didSet{ drawMe() }
    }
    
    var nameLabel = UILabel()
    var numberLabel = UILabel()
    var editButton = PButtonWhite()
    
    //Base init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    
    //Base Coder init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    
    //Common initialization
    func initialize() {
        
        let y = CGFloat(15)
        let marginW = CGFloat(30) * PStyle.screenSizeAdapter()
        let buttonW = CGFloat(70)
        let numberLabelFontSize = CGFloat(26) * PStyle.screenSizeAdapter()
        
        //title view
        nameLabel.frame = CGRect(x:  marginW , y: y, width: UIScreen.main.bounds.width - marginW*3 - buttonW, height: 26)
        nameLabel.textColor =  PStyle.veryDarkGray
        
        //subtitleview
        numberLabel.font = PStyle.baseFont(size: numberLabelFontSize, weight: .regular)
        numberLabel.frame = CGRect(x:  marginW , y: nameLabel.frame.maxY, width: UIScreen.main.bounds.width - marginW*3 - buttonW, height: 44)
        numberLabel.textColor =  PStyle.darkGray
        
        // edit button
        editButton.setTitle(NSLocalizedString("Edit", comment: "Contacts Cell").uppercased(), for: .normal)
        editButton.titleLabel?.font = PStyle.baseFont(size: 20, weight: .regular)
        editButton.frame = CGRect(x: nameLabel.frame.maxX + marginW , y: y+(numberLabel.frame.maxY-y-40)/2, width: buttonW, height: 40)
        
        //add elements
        self.addSubview(self.nameLabel)
        self.addSubview(self.numberLabel)
        self.addSubview(self.editButton)
    }
    
    // update function called when properties changed
    func drawMe(){
        let nameAttributedValue = NSMutableAttributedString(string: "\(name) " , attributes: [NSAttributedString.Key.font : PStyle.baseFont(size: 24*PStyle.screenSizeAdapter(), weight: .light)])
        nameAttributedValue.append(NSMutableAttributedString(string: lastname, attributes: [NSAttributedString.Key.font : PStyle.baseFont(size: 24*PStyle.screenSizeAdapter(), weight: .bold)]))
        nameLabel.attributedText = nameAttributedValue
        numberLabel.text = number
    }
    
    /// animate bg color, used when the cell is the last edited contact
    func lastEditAnimation(){
         UIView.animate(withDuration: 0.6, animations: {
            self.backgroundColor = PStyle.redBgColor
        }) { (_) in
            UIView.animate(withDuration: 1.2, animations: {
                self.backgroundColor = .clear
            })
        }
    }
}
