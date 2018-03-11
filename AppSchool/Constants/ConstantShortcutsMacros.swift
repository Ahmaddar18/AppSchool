//
//  ConstantShortcuts_All.swift
//
//  Created by Ahmad on 1/25/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//
// Localized string helpers

import UIKit
import Foundation

//let  LOCALIZED_STRING(string) NSLocalizedString(string, nil)
//let LANG = LOCALIZED_STRING("globals.lang")
//let LANG_DISPLAY = LOCALIZED_STRING("globals.langDisplay")
// Shared instance shortcuts
let NOTIFICATION_CENTER = NotificationCenter.default
let FILE_MANAGER = FileManager.default
let MAIN_BUNDLE = Bundle.main
let MAIN_THREAD = Thread.main
let MAIN_SCREEN = UIScreen.main
let USER_DEFAULTS = UserDefaults.standard
let APPLICATION = UIApplication.shared
let CURRENT_DEVICE = UIDevice.current
let MAIN_RUN_LOOP = RunLoop.main
let GENERAL_PASTEBOARD = UIPasteboard.general
let CURRENT_LANGUAGE = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)!
let AppDel:AppDelegate = ((UIApplication.shared.delegate as! AppDelegate))

// Network
let NETWORK_ACTIVITY = APPLICATION.isNetworkActivityIndicatorVisible
// Color consts
let CLEAR_COLOR = UIColor.clear
// Application informations
let APPLICATION_NAME = MAIN_BUNDLE.infoDictionary?[kCFBundleNameKey as String]
let APPLICATION_VERSION = MAIN_BUNDLE.object(forInfoDictionaryKey: "CFBundleVersion")
let IN_SIMULATOR = (TARGET_IPHONE_SIMULATOR != 0)


// UserDefauld Keys
let IS_LOGGEDIN = "IS_LOGGEDIN"
let LOGGEDIN_USER_INFO = "LOGGEDIN_USER_INFO"

let USER_TOKEN = "TOKEN"
let NAME = "NOMEUSER"
let EMAIL = "EMAILUSER"


// NSNotifcation

let LOCATION_INFO_FETCH = "LocationInfoFetch"


// Msssages

let CELLULAR_TITLE = "Cellular Network"
let CELLULAR_CONFIRMATION_MSG = "Are you sure you want to continue with cellular data?"
let NETWORK_SUCCESS = "Please connect with internet"
let NETWORK_TITLE = "Network Failure!"
let SUCCESS_TITLE = "Success"
let ALERT_TITLE = "Alert"
let WARNING_TITLE = "Warning"
let TURN_ON_LOCATION_TITLE = "Turn on Location Services"
let TURN_ON_LOCATION_MSG = "1. Tap Settings \n2. Tap Location \n3. Tap While Using the App"
let NOT_NOW = "Not Now"
let SETTINGS = "Settings"
let LOCATION_PATH = "App-Prefs:root=Privacy&path=LOCATION"
let SupportMsg = "Digite a sua mensagem"
let SugestoMsg = "suggesto"

let ForgotBackNotification = "ForgotBackNotification"

// Server path

//------ TEST SERVER -------
let API_Base_Path = "http://52.10.244.229:8888/rest/wsapimob/"
let API_HEADER = "PROD"

//------ LIVE SERVER -------

//let API_Base_Path = "http://apps2.sp.senac.br/rest/wsapimob/"
//let API_HEADER = "HOM"







