//
//  Contact+CoreDataProperties.swift
//  Phonectory
//
//  Created by Maurizio on 01/11/2019.
//  Copyright © 2019 DM. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var lastname: String?
    @NSManaged public var number: String?
    @NSManaged public var timestamp: Date?
  
}
