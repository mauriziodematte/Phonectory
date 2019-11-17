//
//  PCoreDataController.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 3/11/2019.
//  Copyright © 2019 md. All rights reserved.
//

import Foundation
import CoreData
import ContactsUI
import UIKit

class CoreDataController {
    static let shared = CoreDataController()
    
    private var context: NSManagedObjectContext
    private init() {
        let application = UIApplication.shared.delegate as! AppDelegate
        self.context = application.persistentContainer.viewContext
    }
    
    /// cast a CNcontact to a Contact entity in context
    func addCNContactToContact(cnContact:CNContact) -> Contact{
        // user name
        let name:String = cnContact.givenName
        
        // user surname
        let lastname:String = cnContact.familyName
        
        // user phone numberz
        let phoneNumbers:[CNLabeledValue<CNPhoneNumber>] = cnContact.phoneNumbers
        // primary phone number string
        let number:String = phoneNumbers[0].value.stringValue
        
        //add to context
        return addContact(name: name, lastname: lastname, number: number)
    }
    /// add contact entity starting from fields value to context
    func addContact(name: String?, lastname: String?, number: String?) -> Contact{
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: self.context)
        let newContact = Contact(entity: entity!, insertInto: self.context)
        newContact.name = name ?? ""
        newContact.lastname = lastname ?? ""
        newContact.number = number ?? ""
        // timestamp field
        newContact.timestamp = Date()
        
        return newContact
    }
    
    /// update contact with new value
    func updateContact(name: String?, lastname: String?, number: String?, objectID: NSManagedObjectID) -> [(title:String, value:Int)]{
        // retrieve contact from ID
        let contact = context.object(with: objectID) as! Contact
        contact.name = name ?? ""
        contact.lastname = lastname ?? ""
        contact.number = number ?? ""
        return self.save()
    }
    /// delete contact entity
    func deleteContact(objectID: NSManagedObjectID) -> [(title:String, value:Int)]{
        let contact = context.object(with: objectID) as! Contact
        
        self.context.delete(contact)
        return self.save()
        
    }
    // validates entity Contact, if validate and save= true saves it
    func validate(contact:Contact, save:Bool) -> [(title:String, value:Int)]{
        do {
            try contact.validateForInsert()
            if (save){
                return self.save()
            }
            self.context.reset()
            return [(title:String, value:Int)]()
        } catch let error {
            self.context.reset()
             //if errors return error's array asking for all errors if save is required
            return catchErrors(error:  error as NSError, allErrors: save)
        }
    }
    // contexr save
    func save() -> [(title:String, value:Int)]{
       do {
            //save it
            try self.context.save()
            return [(title:String, value:Int)]()
        } catch let error {
            //if errors return error's array
            self.context.reset()
            return catchErrors(error:  error as NSError, allErrors: false)
        }
        
    }
    
    func catchErrors(error:NSError, allErrors:Bool) -> [(title:String, value:Int)]{
        //check all validation error from coredata
        let code = error.code
        var errorArray = [(title:String, value:Int)]()
        // cycle on error descriptions to find all errors. Ok for this purpose
        // * Sure we can find a better way . If there's time refactor
        if code > 0 {
            if code != 1560 {
                errorArray.append((title: error.userInfo["NSValidationErrorKey"] as! String, value: code))
                
            } else{
                guard let h = error.userInfo["NSDetailedErrors"] as? Array<Any> else { return errorArray }
                for e2 in h {
                    let error2 = e2 as! NSError
                    if error2.code != 1560 {
                        errorArray.append((title: error2.userInfo["NSValidationErrorKey"] as! String, value: error2.code))
                        
                    } else{
                        guard let h2 = error2.userInfo["NSDetailedErrors"] as? Array<Any> else { return errorArray }
                        for e3 in h2 {
                            let error3 = e3 as! NSError
                            errorArray.append((title: error3.userInfo["NSValidationErrorKey"] as! String, value: error3.code))
                        }
                    }
                }
            }
        }
        // include only the reg-ex error
        if !allErrors {
            let filtered = errorArray.filter { $0.value == 1680}
            return filtered
        }
        return errorArray
    }
    
    /// retrieve last inseted object from contact entity
    func lastContact() -> Contact?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        //request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            // populate array
            let array = try self.context.fetch(request)
            
            guard array.count > 0 else {print("CoreData - no contacts found"); return nil}
            let lastContact = array[0] as! Contact
            return lastContact
            
        } catch let error {
            // retrieve errors
            print("CoreData - error: \n \(error) \n")
            return nil
        }
    }
    
    /// function that retrieves all contacts from db, can be filtered by search text
    func loadContacts(searchText: String?) ->  [Contact] {
        // etrieve all contacts
        
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        //if text for search is valid then filter for it
        if (searchText != nil && searchText != "") {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR lastname CONTAINS[cd] %@ OR number CONTAINS[cd] %@", searchText!,searchText!,searchText!)
        }
        // sorting rule
        let sort = NSSortDescriptor(key: #keyPath(Contact.lastname), ascending: true,selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sort]
        
        do {
            // populate array
            let array = try self.context.fetch(fetchRequest)
            
            guard array.count > 0 else {print("CoreData - no contacts found"); return []}
            return array
            
        } catch let error {
            // retrieve errors
            print("CoreData - error: \n \(error) \n")
            return []
        }
    }
}
