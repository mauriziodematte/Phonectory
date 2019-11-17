//
//  PContactViewController.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 07/11/2019.
//  Copyright © 2019 DM. All rights reserved.
//
import UIKit
import CoreData
import Foundation

class PContactViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: --- Outlets ---
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: PLabel!
    @IBOutlet weak var nameLabel: PLabelWithAlert!
    @IBOutlet weak var lastnameLabel: PLabelWithAlert!
    @IBOutlet weak var numberLabel: PLabelWithAlert!
    @IBOutlet weak var nameField: PTextField!
    @IBOutlet weak var lastnameField: PTextField!
    @IBOutlet weak var numberField: PTextField!
    @IBOutlet weak var saveButton: PButton!
    @IBOutlet weak var deleteButton: PButtonRed!
    @IBOutlet weak var cancelButton: PButtonWhite!
    
    // MARK: --- Properties ---
    // current edited contact
    var editingContact: Contact?
    
    var name = String()
    var lastname = String()
    var number = String()
    
    // MARK: --- VC methods ---
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare UI
        // setting title properties
        titleLabel.font = PStyle.baseFont(size: 28, weight: .light)
        titleLabel.text = NSLocalizedString("New Contact", comment: "detail").uppercased()
        if editingContact != nil {
            titleLabel.text = NSLocalizedString("Edit Contact", comment: "detail").uppercased()
        }
        
        //name field and label
        nameLabel.titleText = NSLocalizedString("Name", comment: "detail").uppercased()
        nameLabel.alertText = NSLocalizedString("Name field is mandatory", comment: "detail").uppercased()
        nameField.text = name
        
        //lastname field and label
        lastnameLabel.titleText = NSLocalizedString("Lastname", comment: "detail").uppercased()
        lastnameLabel.alertText = NSLocalizedString("Name field is mandatory", comment: "detail").uppercased()
        lastnameField.text = lastname
        
        //number field and label
        numberLabel.titleText = NSLocalizedString("Telephone number", comment: "detail").uppercased()
        numberLabel.alertText = NSLocalizedString("Must be in +XX XXX XXXXXX format", comment: "detail").uppercased()
        numberField.text = number
        
        arrangeViews()
        
        validateFields(textField: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        weak var pvc = self.presentingViewController as? PMainViewController
        
        pvc?.backFromEdit()
    }
    
    // MARK: --- UI methods ---
    /// arranging ui elements
    func arrangeViews() {
        let margin = CGFloat(30)
        let marginH = self.view.frame.size.height/80
        let labelH = CGFloat(26)
        let fieldH = CGFloat(50)
        let logoWidth =  CGFloat(80) * PStyle.screenSizeAdapter()
        let marginLogo = marginH*3
        var y = marginLogo
        
        //title and logo
        logoImageView.frame = CGRect(x: marginLogo, y: y, width: logoWidth , height: logoWidth)
        let titleFrame = CGRect(x: logoImageView.frame.maxY + 10, y: y, width:self.view.frame.size.width -  logoImageView.frame.width - 20 , height:  logoImageView.frame.height)
        self.titleLabel.frame = titleFrame
        y = titleFrame.maxY + marginH*3
        
        // name block
        self.nameLabel.frame = CGRect(x: margin - 4, y: y , width:self.view.frame.size.width - margin*2 + 8 , height: labelH + fieldH + 4)
        self.nameField.frame = CGRect(x: margin, y: y+labelH, width:self.view.frame.size.width - margin*2 , height: fieldH)
        y = self.nameField.frame.maxY + marginH
        
        // lastname block
        self.lastnameLabel.frame = CGRect(x: margin - 4, y: y , width:self.view.frame.size.width - margin*2 + 8 , height: labelH + fieldH + 4)
        self.lastnameField.frame = CGRect(x: margin, y: y+labelH, width:self.view.frame.size.width - margin*2 , height: fieldH)
        y += labelH + fieldH + marginH
        
        // telephone number block
        self.numberLabel.frame = CGRect(x: margin - 4, y: y , width:self.view.frame.size.width - margin*2 + 8 , height: labelH + fieldH + 4)
        self.numberField.frame = CGRect(x: margin, y: y+labelH, width:self.view.frame.size.width - margin*2 , height: fieldH)
        y += labelH + fieldH + marginH*3
        
        let buttonMargin = margin
        let buttonWidth = (self.view.bounds.size.width-buttonMargin*3)/2
        
        var buttonX = buttonMargin - (buttonWidth + buttonMargin)
        if editingContact != nil {
            buttonX = buttonMargin
        }
        // arranging bittuns
        self.deleteButton.frame = CGRect(x: buttonX  , y: y, width: buttonWidth, height: 50)
        self.cancelButton.frame = CGRect(x: buttonX + buttonWidth + buttonMargin , y: y, width: buttonWidth, height: 50)
        self.saveButton.frame = CGRect(x: buttonX + 2*(buttonWidth + buttonMargin) , y: y, width: buttonWidth, height: 50)
        
    }
    
    // MARK: --- Text fields delegation methods ---
    @IBAction func textChanged(sender: UITextField) {
        // do validation of specific element
        validateFields(textField: sender)
        
        // move buttons to save/cancel combination when one of the fields has been changed
        if  self.deleteButton.frame.minX > 0{
            UIView.animate(withDuration: 0.4, animations: {
                self.saveButton.frame = self.cancelButton.frame
                self.cancelButton.frame = self.deleteButton.frame
                self.deleteButton.frame = CGRect(x:  self.cancelButton.frame.minX -  self.cancelButton.frame.width*2  , y:  self.cancelButton.frame.minY, width:  self.cancelButton.frame.width, height:  self.cancelButton.frame.height)
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // do validation of specific element
        validateFields(textField: textField)
        
        // switch between responders
        if textField.tag == 1 {
            lastnameField.becomeFirstResponder()
        } else if  textField.tag == 2 {
            numberField.becomeFirstResponder()
        } else if  textField.tag == 3 {
            textField.resignFirstResponder()
        }
        return false
    }
    
    // MARK: --- IBActions ---
    /// taks back to the main view
    @IBAction func backToMainView(segue: UIStoryboardSegue) {
        weak var pvc = self.presentingViewController as? PMainViewController
        
        pvc?.backFromEdit()
        self.dismiss(animated: true) {
            
        }
    }
    /// saves contact if validation is ok
    @IBAction func saveContact(sender: UIButton) {
        // if is anexisting contaxt
        if editingContact != nil {
            // update existing contact
            let validationErrors = CoreDataController.shared.updateContact(name: nameField.text, lastname: lastnameField.text, number: numberField.text, objectID: editingContact!.objectID)
            // if there are no errors
            if (validationErrors.count == 0){
                // back to main view
                backToMain()
            } else {
                // check again validation e update UI
                validateFields(textField: nil)
            }
        } else{
            // add new contact
            CoreDataController.shared.addContact(name: nameField.text, lastname: lastnameField.text, number: numberField.text)
            let validationErrors = CoreDataController.shared.save()
            // if there are no errors
            if (validationErrors.count == 0){
                // update contact value
                editingContact = CoreDataController.shared.lastContact()
                // back to main view
                backToMain()
            } else {
                // check again validation e update UI
                validateFields(textField: nil)
            }
        }
        
        
    }
     /// deletes contact
    @IBAction func deleteContact(sender: UIButton) {
        if editingContact != nil {
            let result = CoreDataController.shared.deleteContact(objectID: editingContact!.objectID)
            if (result.count == 0){
                editingContact = nil
                backToMain()
            } else {
                // maybe add some interaction
            }
        }
    }
    
    // MARK: --- Custom methods ---
    /// takes back to main setting his editing contact to last one
    func backToMain() {
        weak var pvc = self.presentingViewController as? PMainViewController
        pvc?.editingContact = editingContact
        pvc?.backFromEdit()
        self.dismiss(animated: true) { }
    }
    
    /// simple validation for name
    func checkName(string:String?) {
        // updates correspondin Plabel to show/hide alert
        if (string != nil && string != "") {
            nameLabel.isAlerting = false
        } else{
            nameLabel.isAlerting = true
        }
    }
    
    /// simple validation for lastname
    func checkLastName(string:String?) {
        // updates correspondin Plabel to show/hide alert
        if (string != nil && string != "") {
            lastnameLabel.isAlerting = false
        } else{
            lastnameLabel.isAlerting = true
        }
    }
    
    /// number validation, usese coredata to validate format
    func checkNumber(string:String?) {
        if (string != nil && string != "") {
            let name = self.nameField.text!
            let lastname = self.lastnameField.text!
            let number = string
            let contact = CoreDataController.shared.addContact(name: name, lastname: lastname, number: number)
            // contact validation
            let validationResult = CoreDataController.shared.validate(contact: contact, save: false)
            // updates correspondin Plabel to show/hide alert
            if validationResult.count > 0 {
                self.numberLabel.isAlerting = true
            } else {
                self.numberLabel.isAlerting = false
            }
        } else {
            // add '+' to make easier to write number when empty
            numberField.text  = "+"
            // updates correspondin Plabel to show/hide alert
            self.numberLabel.isAlerting = true
        }
    }
    
    /// validation of fields, push nil value to test all fields
    func validateFields(textField: UITextField?) {
        if textField != nil {
            if textField!.tag == 1 {
                checkName(string: textField!.text)
            } else if  textField!.tag == 2 {
                checkLastName(string: textField!.text)
            } else if  textField!.tag == 3 {
                checkNumber(string: textField!.text)
            }
        } else {
            checkLastName(string: lastnameField.text)
            checkNumber(string: numberField.text)
            checkName(string: nameField.text)
        }
        // enable Save button only when fields are validated
        if self.nameLabel.isAlerting || self.lastnameLabel.isAlerting || self.numberLabel.isAlerting {
            saveButton.isEnabled = false
            saveButton.alpha = 0.6
        } else {
            saveButton.isEnabled = true
            saveButton.alpha = 1
        }
    }
}
