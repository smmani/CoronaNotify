//
//  Utils.swift
//  KFCNotify
//
//  Created by Selvakumar Murugan on 11/04/21.
//  Copyright © 2021 Mani. All rights reserved.
//

import Foundation
import UIKit


class Utils {
    
    class func getCurrentTimeString() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
}

extension UIApplication {
    class func topViewController(base: UIViewController?) -> UIViewController? {

        var rootController = base
        if rootController == nil {
            rootController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        }
        
        if let nav = rootController as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = rootController as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }

        if let presented = rootController?.presentedViewController {
            return topViewController(base: presented)
        }

        return rootController
    }
}
