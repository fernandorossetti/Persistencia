//
//  Momento+CoreDataProperties.swift
//  Diario
//
//  Created by fernando rossetti on 3/8/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import Foundation
import CoreData

extension Moment {
    @NSManaged var subject: String?
    @NSManaged var date: NSDate?
    @NSManaged var about: String?
    @NSManaged var user: User?
}