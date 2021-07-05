//
//  Color+Extension.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 30/6/21.
//

import UIKit

extension UIColor {
    enum custom:String{
        case navigationItemTitle = "#1BB0B2"
        
        var colorValue:UIColor? {
            switch self {
            case .navigationItemTitle:
                return UIColor.getHexColor(self.rawValue);
            }
        }
    }
    class func getHexColor(_ hexString:String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

enum AppColors:String{
    case toInspect = "#FFA31A"
    case toFix = "#F15989"
    case complete = "#44d600"
    
    case insufficient = "#f59ddd"
    case instock = "#a0f59d"
    
    case background = "#ffffff"
}

extension UIColor{
    
    private func getHexColor(hexString:String) -> UIColor{
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func getAppColor(color:String) -> UIColor
    {
        return UIColor.getHexColor(color);
    }
    class func getJobStatusColor(status:TechnicianActiveSitesStatus) -> UIColor
    {
        var color:UIColor!
        switch status {
        case .fix:
            color = UIColor.getHexColor(AppColors.toFix.rawValue);
            break;
        case .inspect:
            color = UIColor.getHexColor(AppColors.toInspect.rawValue);
            break
        case .complete:
            color = UIColor.getHexColor(AppColors.complete.rawValue);
            break
        default:
            color = UIColor.clear
            break;
        }
        return color
    }
}
