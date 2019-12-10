//
//  MovieQueryEntity+CoreDataProperties.swift
//  
//
//  Created by Oleh Kudinov on 10.12.19.
//
//

import Foundation
import CoreData


extension MovieQueryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieQueryEntity> {
        return NSFetchRequest<MovieQueryEntity>(entityName: "MovieQueryEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var query: String?

}
