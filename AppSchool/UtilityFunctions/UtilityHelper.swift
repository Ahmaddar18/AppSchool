//
//  UtilityHelper.swift
//  AppSchool
//
//  Created by Ahmad on 1/25/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import SystemConfiguration
import AVFoundation
import MobileCoreServices
import Reachability

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#endif
/**
 A wrapper around GCD queues. This shouldn't be accessed directly, but rather through
 the helper functions supplied by the APSwiftHelpers package.
 */

public enum QueueType {
    case Main
    case Background
    case LowPriority
    case HighPriority
    
    var queue: DispatchQueue {
        switch self {
        case .Main:
            return DispatchQueue.main
        case .Background:
            return DispatchQueue(label: "com.app.queue",
                                 qos: .background,
                                 target: nil)
        case .LowPriority:
            return DispatchQueue.global(qos: .userInitiated)
        case .HighPriority:
            return DispatchQueue.global(qos: .userInitiated)
        }
    }
}

class UtilityHelper
{
    // MARK: - UIAlertViewController (called from UIViewController)
    
    /**
     * Usage: Helpers.showOKAlert("Alert", message: "Something happened", target: self)
     */
    static func showOKAlert(_ title: String, message: String, target: UIViewController)
    {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        target.present(alertController, animated: true, completion: nil)
    }
    
    static func showNetworkAlert(target: UIViewController)
    {
        let alertController: UIAlertController = UIAlertController(title: NETWORK_TITLE, message: NETWORK_SUCCESS, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        target.present(alertController, animated: true, completion: nil)
    }
    
    /**
     * Usage: Helpers.showOKHelpAlert("Notice", message: "Something happened.", target: self, handler: { (UIAlertAction) -> Void in
     *          // perform help option code here
     *     })
     */
    static func showOKHelpAlert(_ title: String, message: String, target: UIViewController, handler: ((UIAlertAction) -> Void)?)
    {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let helpAction: UIAlertAction = UIAlertAction(title: "Help", style: .default, handler: handler)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(helpAction)
        alertController.addAction(okAction)
        target.present(alertController, animated: true, completion: nil)
    }
    
    /**
     * Usage: Helpers.showContinueAlert("Log Out", message: "Are you sure you want to log out?", target: self, handler: { (UIAlertAction) -> Void in
     *          // perform log out code here
     *     })
     */
    static func showContinueAlert(_ title: String, message: String, target: UIViewController, handler: ((UIAlertAction) -> Void)?)
    {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction: UIAlertAction = UIAlertAction(title: "Continue", style: .default, handler: handler)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        target.present(alertController, animated: true, completion: nil)
    }
    
    class func showTwoButtonsAlert(onVC viewController:UIViewController,title:String,message:String,button1Title:String,button2Title:String,onButton1Click:(()->())?,onButton2Click:(()->())?){
        DispatchQueue.main.async() {
            let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: button1Title, style:.default, handler: { (action:UIAlertAction) in
                onButton1Click?()
            }))
            
            alert.addAction(UIAlertAction(title: button2Title, style:.default, handler: { (action:UIAlertAction) in
                onButton2Click?()
            }))
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Localization
    
    static func getFormattedStringFromNumber(_ number: Double) -> String
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value : number))!
    }
    
    static func getFormattedStringFromDate(_ aDate: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: aDate)
    }
    
    // MARK: - Helpers
    
    class func isNetworkAvailable() -> Bool {
        
        let reachability = Reachability()!
        
        if reachability.connection != .none {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    class func trimStringFromCenterCustomFormate(str:String) -> String? {
        
//        let s1: String = (str as NSString).substring(to: 2)
        let s2: String = (str as NSString).substring(from: str.count - 4)
        
//        let strFinal = String(format:"#%@...%@",s1,s2)
        let strFinal = String(format:"....%@",s2)
        
        return strFinal
    }

    
    class func getLabelHeight(lable: UILabel, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: lable.frame.size.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = lable.text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    class func textfieldPaddingView(_ tf:UITextField) -> UITextField {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.size.height))
        tf.leftViewMode = .always
        tf.leftView = paddingView
        
        return tf
    }
    
    /*
    // MARK: - Set Up Application UI Appearance
    class func setupApplicationUIAppearance() {
//        UILabel.appearance().setSubstituteFontName(UIConfiguration.UIFONTAPP)
        UILabel.appearance().defaultFont = UIFont(name: UIConfiguration.UIFONTAPP, size: 15)
        let titleTextAttributeTabBarItem:[String:AnyObject] = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIConfiguration.getUIFONTAPPREGULAR(sizeFont: 17)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(titleTextAttributeTabBarItem, for: UIControlState())
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIConfiguration.getUIFONTBOLD(sizeFont: 17)]
        
        
        
        let titleTextAttributeBarButtonItem:[String:AnyObject] = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIConfiguration.getUIFONTAPPREGULAR(sizeFont: 16)
        ]
        if #available(iOS 9.0, *) {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(titleTextAttributeBarButtonItem, for: UIControlState())
        } else {
            // Fallback on earlier versions
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([NSTextEffectAttributeName: UIColor.white, NSFontAttributeName: UIConfiguration.getUIFONTAPPREGULAR(sizeFont: 16)], for: .normal)
        
        let rect:CGRect! = CGRect(x: 0 ,y: 0, width: Constants.getApplicationDelegate().window!.frame.size.width, height: 64)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIConfiguration.MainNavBackColor.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UINavigationBar.appearance().setBackgroundImage(image, for: UIBarMetrics.default)
        
    }
    */
    
    // MARK: - Validations
    
    class func isValidEmailAddress(_ testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidateSaudiaNumber(_ checkString: NSString) -> Bool {
        //+966126123100
        //http://regexlib.com/Search.aspx?k=saudi&c=-1&m=-1&ps=20
        //https://gist.github.com/homaily/8672499
        //https://regex101.com
        let numcharacters: CharacterSet = CharacterSet(charactersIn: "^(009665|9665|+9665|05|+966)(5|0|3|6|4|9|1|8|7|2)([0-9]{7})")
        var characterCount: Int32 = 0
        //        var i: Int
        for i in 0 ..< checkString.length {
            let character: unichar = checkString.character(at: i)
            if !numcharacters.contains(UnicodeScalar(character)!) {
                characterCount += 1
            }
        }
        if characterCount == 0 {
            return true
        } else {
            return false
            
        }
    }
    
    class func isValidateAlphabet(_ checkString: NSString) -> Bool {
        let numcharacters: CharacterSet = CharacterSet(charactersIn: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        var characterCount: Int32 = 0
        //        var i: Int
        for i in 0 ..< checkString.length {
            let character: unichar = checkString.character(at: i)
            if !numcharacters.contains(UnicodeScalar(character)!) {
                characterCount += 1
            }
        }
        if characterCount == 0 {
            return true
        } else {
            return false
            
        }
    }
    
    class func isValidateAlphabetWithWhiteSpace(_ checkString: NSString) -> Bool {
        let numcharacters: CharacterSet = CharacterSet(charactersIn: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        var characterCount: Int32 = 0
        //        var i: Int
        
        for i in 0 ..< checkString.length {
            let character: unichar = checkString.character(at: i)
            if !numcharacters.contains(UnicodeScalar(character)!) {
                characterCount += 1
            }
        }
        if characterCount == 0 {
            return true
        } else {
            return false
            
        }
    }
    
    class func isValidStringNumericPlus(_ checkString: NSString) -> Bool {
        let numcharacters: CharacterSet = CharacterSet(charactersIn: "0123456789+")
        var characterCount: Int32 = 0
        //        var i: Int
        for i in 0 ..< checkString.length {
            let character: unichar = checkString.character(at: i)
            if !numcharacters.contains(UnicodeScalar(character)!) {
                characterCount += 1
            }
        }
        if characterCount == 0 {
            return true
        } else {
            return false
            
        }
    }
    
    class func changePhoneStandardFormate(str:String) -> String? {
        
        if (str.count >= 7) {
            
            let s6: String = (str as NSString).substring(to: 6)
            
            let s1: String = (s6 as NSString).substring(to: 3)
            let s2: String = (s6 as NSString).substring(from: 3)
            var s3: String = ""
            
            if (str.count == 7) {
                s3 = (str as NSString).substring(from: str.count - 1)
            }
            if (str.count == 8) {
                s3 = (str as NSString).substring(from: str.count - 2)
            }
            if (str.count == 9) {
                s3 = (str as NSString).substring(from: str.count - 3)
            }
            if (str.count == 10) {
                s3 = (str as NSString).substring(from: str.count - 4)
            }
            if (str.count == 11) {
                s3 = (str as NSString).substring(from: str.count - 5)
            }
            
            let strFinal = String(format:"%@-%@-%@",s1,s2,s3)
            
            return strFinal
        }
        
        return str
        
    }
    
    // MARK: - Get Preferred Language
    
    class func getPrefferedLanguage() -> String {
        for languageItem in Locale.preferredLanguages {
            if languageItem == "en" || languageItem == "ru" || languageItem == "uk" || languageItem == "de" || languageItem == "fr" || languageItem == "it" || languageItem == "es" || languageItem == "ar" {
                return languageItem
            }
        }
        return "en"
    }
    
    // MARK: - Date Conversions
    
    class func convertStringDate(_ date: String, formatFrom: String, formatTo: String) -> String {
        let dateString: String = date
        let dateFormatter: DateFormatter = DateFormatter()
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        dateFormatter.dateFormat = formatFrom
        var dateFromString: Date
        dateFromString = dateFormatter.date(from: dateString)!
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = formatTo
        //Optionally for time zone converstions
        formatter.timeZone = TimeZone(identifier: "...")
        let birthday: String = formatter.string(from: dateFromString)
        return birthday
    }
    
    class func convertDateToString(_ date: Date, withFormat Format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = Format
        let stringFromDate: String = formatter.string(from: date)
        return stringFromDate
    }
    
    class func convertStringToDate(_ date: String, formatFrom: String) -> Date {
        let myFormatter: DateFormatter = DateFormatter()
        myFormatter.timeZone = TimeZone.current
        //    [myFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:@"Gregorion"]];
        myFormatter.dateFormat = formatFrom
        let myDate: Date = myFormatter.date(from: date)!
        return myDate
    }
    
    class func convertTimeFormat(time: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "hh:mm a"
        
        let dateString = dateFormatter.string(from: date)
        print("New Time : \(dateString)")
        
        return dateString
    }
    
    // MARK: - UIView Related
    
    class func setViewBorder(_ yourView: UIView, withWidth borderWidth: CGFloat, andColor borderColor: UIColor, cornerRadius radius: CGFloat, andShadowColor shadowColor: UIColor, shadowRadius: CGFloat) {
        // border radius
        yourView.layer.cornerRadius = radius
        // border
        yourView.layer.borderColor = borderColor.cgColor
        yourView.layer.borderWidth = borderWidth
        // drop shadow
        yourView.layer.shadowColor = shadowColor.cgColor
        yourView.layer.shadowOpacity = 0.8
        yourView.layer.shadowRadius = shadowRadius
        yourView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }

    // MARK: - Key Window
    class func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    class func getAppWindow() -> UIWindow? {
        let ad  = UIApplication.shared.delegate as! AppDelegate
        return ad.window
    }
    
    // MARK: - Measure height/width from String
    class func measureWidthForText(_ text:NSString?,font:UIFont)->CGFloat{
        if text != nil{
            let tmpLabel = UILabel(frame: CGRect.zero)
            tmpLabel.font = font
            tmpLabel.text = text as String!
            let size = tmpLabel.intrinsicContentSize.width
            return size
        }
        return 0
    }
    
    class func measureHeightForText(_ text:String,font:UIFont)->CGFloat{
        let tmpLabel = UILabel(frame: CGRect.zero)
        tmpLabel.font = font
        tmpLabel.text = text as String
        let size = tmpLabel.intrinsicContentSize.height
        return size
    }
    
    class func requiredHeightForLabelWith(_ width:CGFloat, font:UIFont, text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    
    // MARK: - Mail
    /**
     Open Mail app Compose view
     
     - parameter email:   an email address
     - parameter subject: a subject
     - parameter body:    a body
     */
    class func openMailApp(_ email:String, subject:String, body:String) {
        let toEmail = email
        let toSubject = subject
        let toBody = body
        
        if let
            urlString = ("mailto:\(toEmail)?subject=\(toSubject)&body=\(toBody)").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let _ = URL(string:urlString) {
//            UIApplication.shared.openURL(url)
        }
    }
    
    
}


