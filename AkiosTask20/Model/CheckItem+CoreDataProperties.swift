//
//  CheckItem+CoreDataProperties.swift
//  AkiosTask20
//
//  Created by Nekokichi on 2020/09/30.
//
//

import Foundation
import CoreData

extension CheckItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckItem> {
        NSFetchRequest<CheckItem>(entityName: "CheckItem")
    }

    @NSManaged public var isChecked: Bool
    @NSManaged public var name: String?

}

extension CheckItem: Identifiable {

}
