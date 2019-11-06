//
//  PCoreDataController.swift
//  Phonectory
//
//  Created by Maurizio Demattè on 3/11/2019.
//  Copyright © 2019 md. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataController {
    static let shared = CoreDataController()
  
    private var context: NSManagedObjectContext
    private init() {
        let application = UIApplication.shared.delegate as! AppDelegate
        self.context = application.persistentContainer.viewContext
    }
    func addContact(name: String, surname: String, number: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: self.context)
        
        let newContact = Contact(entity: entity!, insertInto: self.context)
        newContact.name = name
        newContact.surname = surname
        newContact.number = number
        do {
            try self.context.save()
        } catch let error {
            print("Contact \(newContact.name!) saving error: \n \(error) \n")
        }
        
    }

    func loadAllContacts() ->  [Contact] {
    print("[CDC] Recupero tutti i libri dal context ")
    
    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
    
    do {
        let array = try self.context.fetch(fetchRequest)
        
        guard array.count > 0 else {print("[CDC] Non ci sono elementi da leggere "); return []}
        
        for x in array {
            let contact = x
            print("[CDC] Libro \(contact.name!) - Autore \(contact.surname!)")
        }
        return array
    } catch let errore {
        print("[CDC] Problema esecuzione FetchRequest")
        print("  Stampo l'errore: \n \(errore) \n")
        return []
    }
}
}
