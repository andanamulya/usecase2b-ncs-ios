//
//  UISearchBar+Extension.swift
//  SP_Usecase
//
//  Created by Zhou Hao on 1/7/21.
//

import UIKit

extension UISearchBar {
    
    func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }

        for view in subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
    }
}
