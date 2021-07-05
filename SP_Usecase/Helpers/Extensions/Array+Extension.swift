//
//  Array+Extension.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit

extension Array where Element: Equatable {
    func filtered(using predicate: NSPredicate) -> Array {
        return (self as NSArray).filtered(using: predicate) as! Array
    }
}
