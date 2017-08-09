//
//  Instamojo.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation
import UIKit

public class Instamojo: NSObject {

    static var instance: Bool = false

    /**
     * Initizalise Instamojo
     *
     */
    public class func setup() {
        instance = true
        Logger.enableLog(enable: true)
        Urls.setBaseUrl(baseUrl: Constants.DefaultBaseUrl)
    }

    public class func enableLog(option: Bool) {
        if initiliazed() {
            Logger.enableLog(enable: option)
        } else {
            return
        }
    }

    /**
     * Sets the base url for all network calls
     *
     * @param url String
     */
    public class func setBaseUrl(url: String) {
        Urls.setBaseUrl(baseUrl: url)
    }

    private class func initiliazed() -> Bool {
        if Instamojo.instance {
            return true
        } else {
            return false
        }
    }

    private class func resetDefaults() {
        UserDefaults.standard.setValue(nil, forKey: "USER-CANCELLED-ON-VERIFY")
        UserDefaults.standard.setValue(nil, forKey: "USER-CANCELLED")
        UserDefaults.standard.setValue(nil, forKey: "ON-REDIRECT-URL")
    }

    /**
     * Invoke Pre Created Payment UI
     *
     * @param order Order
     */
    public class func invokePaymentOptionsView(order: Order, onViewController viewController: UIViewController) {
        self.resetDefaults()
        let storyBoard: UIStoryboard = Constants.getStoryboardInstance()
        if let viewController: PaymentOptionsView = storyBoard.instantiateViewController(withIdentifier: Constants.PaymentOptionsViewController) as? PaymentOptionsView {
            viewController.order = order
            
            if viewController is UINavigationController {
                let navController: UINavigationController? = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)
                navController?.pushViewController(viewController, animated: true)
            }
            else {
                print("error")
            }
        }
    }
    
    /**
     * Invoke Payment For Custom UI
     *
     * @param params BrowserParams
     */
    public class func makePayment(params: BrowserParams) {
        self.resetDefaults()
        let storyBoard: UIStoryboard = Constants.getStoryboardInstance()
        let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.PaymentOptionsJuspayViewController) as! PaymentViewController
        viewController.params = params
        let window: UIWindow? = UIApplication.shared.keyWindow
        let rootClass = window?.rootViewController
        if rootClass is UINavigationController {
            let navController: UINavigationController? = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)
            navController?.pushViewController(viewController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: (window?.rootViewController)!)
            window?.rootViewController = nil
            window?.frame = UIScreen.main.bounds
            window?.rootViewController = navController
            navController.pushViewController(viewController, animated: true)
        }
    }

}
