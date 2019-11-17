//
//  ViewController.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 3/11/2019.
//  Copyright © 2019 md. All rights reserved.
//

import UIKit
import ContactsUI

let cellHeight = CGFloat(100)

class PMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CNContactPickerDelegate {
    
    // MARK: --- Outlets ---
    @IBOutlet weak var contactsTable: UITableView!
    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var addNewButton: UIButton!
    
    // MARK: --- Properties ---
    private var overlay = UIControl()
    var importedContact: CNContact?
    var editingContact: Contact?
    var contacts: [Contact] = []
    var searchString = ""
    
    // MARK: --- VC methods ---
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // search for
        contacts = CoreDataController.shared.loadContacts(searchText:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set variables & constant
        var y = searchBar.frame.minY
        let searchBarH = CGFloat(64)
        let footerH = CGFloat(100)
        let buttonMargin = CGFloat(25)
        let buttonWidth = (self.view.bounds.size.width-buttonMargin*3)/2
        
        // logo attributed text
        let logoText = NSMutableAttributedString(string: NSLocalizedString("Phone", comment: "list"), attributes: [NSAttributedString.Key.font : PStyle.baseFont(size: 36, weight: .bold)])
        logoText.append(NSMutableAttributedString(string: NSLocalizedString("ctory", comment: "list"), attributes: [NSAttributedString.Key.font : PStyle.baseFont(size: 36, weight: .light)]))
        
        // logo view
        logo.attributedText = logoText
        logo.textColor =  PStyle.darkGray
        logo.frame = CGRect(x: 0, y: 25, width: self.view.bounds.size.width , height: y-25)
        
        // search bar
        searchBar.frame = CGRect(x: 0, y: y, width: self.view.bounds.size.width , height: searchBarH)
        searchBar.barTintColor = PStyle.darkGray
        searchBar.delegate = self
        y += searchBarH
        
        // set tableview
        contactsTable.frame = CGRect(x: 0, y:  y, width: self.view.bounds.size.width, height: PStyle.usableAreaMarginHeight(view: self) -  y - footerH)
        
        contactsTable?.register(PContactTableViewCell.classForCoder(), forCellReuseIdentifier: "PContactTableViewCell")
        contactsTable.backgroundColor = .init(white: 1, alpha: 0.4)
        contactsTable.bounces = true
        contactsTable.delegate = self
        contactsTable.dataSource = self
        contactsTable.layer.borderWidth = 1
        contactsTable.layer.borderColor = UIColor.black.cgColor
        contactsTable.tableFooterView = UIView()
        y = contactsTable.frame.maxY+20
        
        // Add new contact button
        addNewButton.frame = CGRect(x: buttonWidth + buttonMargin * 2 , y: y, width: buttonWidth, height: 50)
        addNewButton.setTitle(NSLocalizedString("New", comment: "list").uppercased(), for: .normal)
        
        // Import from contacts
        importButton.frame = CGRect(x: buttonMargin , y: y, width: buttonWidth, height: 50)
        importButton.setTitle(NSLocalizedString("Import", comment: "list").uppercased(), for: .normal)
        
        // overlay view when keyboard is out
        overlay.backgroundColor = UIColor.init(white: 0, alpha: 0.0)
        overlay.frame = CGRect(x: 0, y:  searchBar.frame.maxY, width: self.view.bounds.size.width, height: PStyle.usableAreaMarginHeight(view: self) -  searchBar.frame.maxY)
        overlay.alpha = 0
        overlay.addTarget(self, action: #selector(closeOverlay), for: .touchUpInside)
        self.view.addSubview(overlay)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails"{
            if let vc = segue.destination as? PContactViewController{
                // set properties of editing contact to contact imported from Contacts
                if importedContact != nil {
                    vc.name = importedContact?.givenName ?? ""
                    vc.lastname = importedContact?.familyName ?? ""
                    if importedContact?.phoneNumbers.count ?? 0 > 0 {
                        vc.number = importedContact?.phoneNumbers[0].value.stringValue ?? ""
                    }
                    return
                }
                // set properties of editing contact to contact selected for editing
                if editingContact != nil{
                    vc.editingContact = editingContact
                    vc.name = editingContact?.name ?? ""
                    vc.lastname = editingContact?.lastname ?? ""
                    vc.number = editingContact?.number ?? ""
                }
            }
        }
    }
    
    
    // MARK: --- Table view delegation methods ---
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.contactsTable.dequeueReusableCell(withIdentifier: "PContactTableViewCell", for: indexPath) as? PContactTableViewCell
        if cell == nil { cell = PContactTableViewCell() }
        
        let contact = contacts[indexPath.row]
        
        cell?.backgroundColor = .clear
        cell?.name = contact.name ?? ""
        cell?.lastname = contact.lastname ?? ""
        cell?.number = contact.number ?? ""
        cell?.selectionStyle = .none
        cell?.editButton.tag = indexPath.row
        cell?.editButton.addTarget(self, action: #selector(editContact), for: .touchUpInside)
        if (editingContact != nil && contact.objectID ==  editingContact!.objectID) {
            // add animation to show last edited contact
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                cell?.lastEditAnimation()
                self.editingContact = nil
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  self.singleBeer(show: true, beer: beerList[indexPath.row])
    }
    
    // MARK: --- Search bar delegation methods ---
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.overlay(show: true, searching: true)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.overlay(show: false, searching: true )
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        contacts = CoreDataController.shared.loadContacts(searchText: searchBar.text)
        searchBar.endEditing(true)
        contactsTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //uncomment to retrieve list while typing
        contacts = CoreDataController.shared.loadContacts(searchText: searchBar.text)
        contactsTable.reloadData()
    }
    
    // MARK: --- CNContact delegation methods ---
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
        let dbcontact =  CoreDataController.shared.addCNContactToContact(cnContact: contact)
        // try to validate contact data, if ok they will be saved to db
        let result = CoreDataController.shared.validate(contact: dbcontact, save: true)
        
        picker.dismiss(animated:true, completion: {
            //if there are validation errors
            if (result.count > 0){
                //we go to edit view to let user correct them
                self.importedContact = contact
                self.performSegue(withIdentifier: "goToDetails", sender: self)
            } else{
                // we set the editing contact
                self.editingContact = CoreDataController.shared.lastContact()
                // else we reload data and table
                self.contacts = CoreDataController.shared.loadContacts(searchText:nil)
                self.contactsTable.reloadData()
            }
        })
    }
    
    // MARK: --- IBActions ---
    /// opens the contact picker
    @IBAction func importContact(sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        
        contactPicker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        present(contactPicker, animated: true)
        
    }
    
    // MARK: --- Custom methods ---
    /// exceuted when coming back from edit
    func backFromEdit() {
        // editingContact = nil
        importedContact = nil
        contacts = CoreDataController.shared.loadContacts(searchText:searchBar.text)
        
        contactsTable.reloadData()
        // of we have an edited or new added contact we scroll to it
        if (editingContact != nil) {
            if let index = contacts.firstIndex(where: { $0.objectID ==  editingContact!.objectID}) {
                contactsTable.scrollToRow( at: NSIndexPath(row: index, section: 0) as IndexPath, at: .top, animated: true)
            }
        }
        
    }
    /// open theoverlay control used to take back from search when touching outside the keyboard
    @objc func overlay(show: Bool, searching: Bool){
        if searching {
            overlay.frame = CGRect(x: 0, y:  searchBar.frame.maxY, width: self.view.bounds.size.width, height: self.view.bounds.size.height -  searchBar.frame.maxY)
        } else {
            overlay.frame = self.view.frame
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.overlay.alpha = show == true ? 100 : 0
        }, completion: nil)
    }
    /// closeing the overlay control used to take back from search when touching outside the keyboard
    @objc func closeOverlay(){
        if searchBar.isFirstResponder {
            searchBar.endEditing(true)
        }
    }
    /// edit contact going to the editing view
    @objc func editContact(sender: UIButton) {
        editingContact = contacts[sender.tag]
        self.performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
}


