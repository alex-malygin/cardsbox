//
//  Card+CoreDataProperties.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/26/21.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var userName: String?
    @NSManaged public var cardNumber: String?

}

extension Card : Identifiable {

}
