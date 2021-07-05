//
//  BaseProtocol.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 29/6/21.
//

import UIKit

protocol BaseProtocol:AnyObject {
    /// Delegate protocol to display error message
    /// - Parameter errorString: error message
    func displayError(errorString:String)
    
    /// Delegate protocol to display error message
    /// - Parameter errorString: error message
    func displaySuccess(message:String?)
    
    /// Delegate protocol to navigate to specific view controller
    /// - Parameter identifier: storyboard viewcontroller identifier
    func navigateToViewController(identifier:UIStoryboard.vcIndentifier)
    
    func reloadTableData()
}

extension BaseProtocol{
    /// Delegate protocol to navigate to specific view controller
    /// - Parameter identifier: storyboard viewcontroller identifier
    func navigateToViewController(identifier:UIStoryboard.vcIndentifier){
        
    }
    
    /// Delegate protocol to display error message
    /// - Parameter errorString: error message
    func displaySuccess(message:String?){
        
    }
    /// Delegate protocol to display error message
    /// - Parameter errorString: error message
    func displayError(errorString:String){
        
    }
    
    /// Delegate reload to reload table view data
    func reloadTableData(){
        
    }
}
