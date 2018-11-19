//
//  User+CoreDataProperties.swift
//  Diario
//
//  Created by fernando rossetti on 3/8/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import Foundation
import CoreData

extension User {
    @NSManaged var name: String?
    @NSManaged var password: String?
    @NSManaged var email: String?
    @NSManaged var last_name: String?
    @NSManaged var birth_date: NSDate?
    @NSManaged var momentos: NSSet?
}