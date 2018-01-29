//
//  UIHelper.swift
//  AppSchool
//
//  Created by Mayck Xavier on 25/12/17.
//  Copyright © 2017 Mayck Xavier. All rights reserved.
//

import Foundation
import UIKit

class UIHelper{
    static func showAlertController(uiController: UIViewController, message: String, title: String =  "Informação"){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        uiController.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor.red
        alertController.view.backgroundColor = UIColor.red
        alertController.view.layer.cornerRadius = 0.1 * alertController.view.bounds.size.width
    }
    
    static func activityIndicator(view: UIView, title: String) -> UIView {
        var strLabel = UILabel()
        var activityIndicator = UIActivityIndicatorView()
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        let subView: UIView = UIView()
        view.addSubview(subView)
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        subView.addSubview(effectView)
        
        return subView
    }
    
    static func stopsIndicator(view: UIView){
        view.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    static func decodeImageFromData( strData: String) -> UIImage {
        
        //let dataString:String = strData
        let dataDecoded:NSData = NSData(base64Encoded: strData, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        
        return decodedimage
    }
}
