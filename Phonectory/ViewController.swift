//
//  ViewController.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 3/11/2019.
//  Copyright © 2019 md. All rights reserved.
//

import UIKit
let cellHeight = CGFloat(140)

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var contactsTable: UITableView!
       @IBOutlet weak var logo: UILabel!
       @IBOutlet weak var searchBar: UISearchBar!
       @IBOutlet weak var addNewButton: UIButton!
    
    
       private var overlay = UIControl()
       //private var singleBeerView: BBBeerView!
       private var spinnerView = UIView()
       private var conctatsFiltersView = UIScrollView()
       private var contactell = UITableViewCell()
    
    let searchController = UISearchController(searchResultsController: nil)
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    let beerPagination = 25
    
    var beerTypes = ["Blonde","Lager","Malts","Stout","Ale"]
    var filters =  [String]()
    var filtered = [[String:Any]]()
    var addCall = true
    var page = 0
    var searchString = ""
    

   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getContacts()
        //CoreDataController.shared.addContact(name: "Stefanod", surname: "Dematte", number: "+31 55758812")
        //self.view.backgroundColor = PStyle.blue
        // set variables & constant
              let searchBarH = CGFloat(64)
              let footerH = CGFloat(100)
              let filterViewH = CGFloat(30)
              let marginH = CGFloat(15)
              let marginW = CGFloat(15)
              var y = searchBar.frame.minY
        
        // logo view
             let logoText = NSMutableAttributedString(string: NSLocalizedString("Phone", comment: "list"), attributes: [NSAttributedString.Key.font : PStyle.baseFont(size: 36, weight: .bold)])
             logoText.append(NSMutableAttributedString(string: NSLocalizedString("ctory", comment: "list"), attributes: [NSAttributedString.Key.font : PStyle.baseFont(size: 36, weight: .light)]))
             logo?.attributedText = logoText
        logo?.textColor =  PStyle.darkGray
        
       // search bar
         searchBar.frame = CGRect(x: 0, y: y, width: self.view.bounds.size.width , height: searchBarH)
          searchBar.barTintColor = PStyle.veryDarkGray
          searchBar.delegate = self
         y += searchBarH
        let h = PStyle.usableAreaMarginHeight(view: self)
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
        y = contactsTable.frame.maxY+25
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        addNewButton.frame = CGRect(x: 50 , y: y, width: self.view.bounds.size.width-100, height: 50)
      
        addNewButton.titleLabel?.font = PStyle.baseFont(size:32, weight: .ultraLight)
        addNewButton.layer.cornerRadius = 12
     addNewButton.backgroundColor = PStyle.darkGray
        addNewButton.setTitleColor(PStyle.lightBlue, for: .normal)
        addNewButton.setTitle(NSLocalizedString("Add Contact", comment: "list").uppercased(), for: .normal)
        
    }

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    //CUSTOM FUNCTION
    func updateSearchResults(for searchController: UISearchController) {
      // TODO
    }
    func getContacts() {
        contacts = CoreDataController.shared.loadAllContacts()
    }
    
    @IBAction func saveContact(sender: UIButton) {
//           guard !self.txt_BookName.text!.isEmpty else {return}
//           guard !self.txt_BookAuthor.text!.isEmpty else {return}
//           guard !self.txt_BookNumPage.text!.isEmpty else {return}
//
//           let nome = self.txt_BookName.text!
//           let autore = self.txt_BookAuthor.text!
//           let num_page = Int(self.txt_BookNumPage.text!)!
           
          
       }
    
// table view delagation methods
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return contacts.count
 }
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return cellHeight
 }
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     var cell = self.contactsTable.dequeueReusableCell(withIdentifier: "PContactTableViewCell", for: indexPath) as? PContactTableViewCell
     if cell == nil { cell = PContactTableViewCell() }
     
     // if is last cell, ask for another page
    let contact = contacts[indexPath.row]
    cell?.backgroundColor = .init(white: 0, alpha: 0.75)
    cell?.backgroundColor = .clear
     cell?.numberLabel.text = contact.number
    let logoText = NSMutableAttributedString(string: "\(contact.name ?? "") " , attributes: [NSAttributedString.Key.font : PStyle.baseFont(size: 24, weight: .light)])
    logoText.append(NSMutableAttributedString(string: contact.surname ?? "", attributes: [NSAttributedString.Key.font : PStyle.baseFont(size: 24, weight: .bold)]))
              
                cell?.nameLabel.attributedText = logoText
     cell?.selectionStyle = .none
     return cell!
 }
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   //  self.singleBeer(show: true, beer: beerList[indexPath.row])
 }

 // search bar delegation methods
 func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    // self.overlay(show: true, searching: true)
     
 }
 
 func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
  //   self.overlay(show: false, searching: true )
     
 }
 
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     searchString =  searchBar.text ?? ""
     page = 0
     getContacts()
     searchBar.endEditing(true)
 }
 
 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     //uncomment to retrieve list while typing --not needed
  /* searchString =  searchBar.text ?? ""
     page = 0
     retrieveBeerList()*/
 }
 
}


/// table view cell for list of beers
class PContactTableViewCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var numberLabel = UILabel()
    var descriptionLabel = UILabel()
    
    var editButton = UIButton()
    
    //Base reuse init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    
    //Base Coder init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    
    //Initialization
    func initialize() {
        let marginW = CGFloat(40)
        var y = CGFloat(15)
        
        //title view
        nameLabel.frame = CGRect(x:  marginW , y: y, width: UIScreen.main.bounds.width - marginW*2, height: 26)
        nameLabel.textColor =  PStyle.veryDarkGray
        y = nameLabel.frame.maxY
         
        //subtitleview
           numberLabel.font = PStyle.baseFont(size: 36, weight: .regular)
       //  numberLabel.backgroundColor = .white
        numberLabel.frame = CGRect(x:  marginW , y: y, width: UIScreen.main.bounds.width - marginW*2, height: 44)
        numberLabel.textColor =  PStyle.darkGray
        y = numberLabel.frame.maxY + 4
        
   
        // ad button
        editButton.setTitle(NSLocalizedString("Edit >", comment: "BeerCell").uppercased(), for: .normal)
        editButton.frame = CGRect(x: marginW , y: y, width: 80, height: 32)
        editButton.setTitleColor(PStyle.veryDarkGray, for: .normal)
        editButton.titleLabel?.font = PStyle.baseFont(size:20, weight: .ultraLight)
        editButton.layer.cornerRadius = 12
          editButton.backgroundColor = .white
        self.addSubview(self.nameLabel)
        self.addSubview(self.numberLabel)
        self.addSubview(self.editButton)
        
    }
}
