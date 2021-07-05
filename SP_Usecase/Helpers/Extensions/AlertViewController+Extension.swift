//
//  AlertViewController+Extension.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit

extension UIAlertController {
    
    /// Override  tp force user interface style to .light
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
    }
}
