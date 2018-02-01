//
//  UIViewController+Helper.swift
//  AppSchool
//
//  Created by Safyan on 23/01/18.
//  Copyright © 2018 Safyan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /*
    func showErrorAlert(_ error: JennairError) {
        let alertController = UIAlertController(title: error.title, message: error.detail, preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(accept)
        
        self.present(alertController, animated: true, completion:nil)
    }
    */
    func showErrorAlert(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: title!, message: message!, preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
        
        alertController.addAction(accept)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showAlertWithMessage(_ title: String?, message: String?, btnTitle: String?) {
        
        let alertController = UIAlertController(title: title!, message: message!, preferredStyle: .alert)
        let accept = UIAlertAction(title: btnTitle, style: .default, handler: nil)
        alertController.addAction(accept)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    class func topViewController() -> UIViewController {
        var rootVC = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        if rootVC.isKind(of: UITabBarController.self) {
            rootVC = (rootVC as! UITabBarController).selectedViewController!
        } else if rootVC.isKind(of: UINavigationController.self) {
            rootVC = (rootVC as! UINavigationController).topViewController!
        }
        while rootVC.presentedViewController != nil {
            rootVC = rootVC.presentedViewController!
            if rootVC.isKind(of: UINavigationController.self) {
                rootVC = (rootVC as! UINavigationController).topViewController!
            }
        }
        return rootVC
    }
    
    func setRootController(identifierName: String) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifierName)
        let navC = UINavigationController(rootViewController: vc!)
        let window = APPLICATION.delegate?.window
        
        window??.rootViewController = navC
    }
    
    func goToViewControllerIdentifier(identifierName: String, animation: Bool) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifierName)
        self.navigationController?.pushViewController(vc!, animated: animation)
    }
}
