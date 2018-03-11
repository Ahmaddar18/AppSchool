//
//  BaseViewController.swift
//  AppSchool
//
//  Created by Fasih on 1/31/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var sidebarView: SidebarView!
    var blackScreen: UIView!
    //var dictUser: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    func initializeMenu() {
        
        let dictUser = USER_DEFAULTS.value(forKey: LOGGEDIN_USER_INFO) as? NSDictionary
        self.title = String(format: "Área Exclusiva de %@",(dictUser?[NAME] as? String)!)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor.orangeColor()
        self.navigationController?.isToolbarHidden = true
        
        let btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(btnMenuAction))
        btnMenu.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem = btnMenu
        
        sidebarView=SidebarView(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height))
        sidebarView.delegate=self
        sidebarView.layer.zPosition=100
        self.view.isUserInteractionEnabled=true
        self.navigationController?.view.addSubview(sidebarView)
        
        blackScreen=UIView(frame: self.view.bounds)
        blackScreen.backgroundColor=UIColor(white: 0, alpha: 0.5)
        blackScreen.isHidden=true
        self.navigationController?.view.addSubview(blackScreen)
        blackScreen.layer.zPosition=99
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
    }
    
    // MARK: - Side Menu Methods
    
    @objc func btnMenuAction() {
        blackScreen.isHidden=false
        UIView.animate(withDuration: 0.3, animations: {
            if (ConstantDevices.IS_IPHONE && ConstantDevices.IS_IPHONE_5){
                self.sidebarView.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width-75, height: self.sidebarView.frame.height)
            }else{
                self.sidebarView.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width-75, height: self.sidebarView.frame.height)
            }
            
        }) { (complete) in
            self.blackScreen.frame=CGRect(x: self.sidebarView.frame.width, y: 0, width: self.view.frame.width-self.sidebarView.frame.width, height: self.view.bounds.height+100)
        }
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
    }
    
    // MARK:- Side Menu Functions
    func openCalenderView(){
        goToViewControllerIdentifier(identifierName: "calenderVC", animation: false)
    }
    
    func openNotesView(){
        goToViewControllerIdentifier(identifierName: "NotesViewController", animation: false)
    }
    
    func openFrequencyView(){
        goToViewControllerIdentifier(identifierName: "FrequencyVC", animation: false)
    }
    
    func openFinancialView(){
        goToViewControllerIdentifier(identifierName: "FinancialVC", animation: false)
    }
    
    func openSecretaryView(){
        goToViewControllerIdentifier(identifierName: "SecretaryVC", animation: false)
    }
    
    func openDisclosureView(){
        goToViewControllerIdentifier(identifierName: "DisclosureVC", animation: false)
    }
    
    func openEstagiosView(){
        goToViewControllerIdentifier(identifierName: "EstagiosVC", animation: false)
    }
    
    func openAmbientView(){
        goToViewControllerIdentifier(identifierName: "AmbienceVC", animation: false)
    }
    
    func openConcenienceView(){
        goToViewControllerIdentifier(identifierName: "ConvenienceVC", animation: false)
    }
    
    func openSupportView(){
        goToViewControllerIdentifier(identifierName: "SupportInnerVC", animation: false)
    }
    
    func openSugestoesView(){
        goToViewControllerIdentifier(identifierName: "SugestoesVC", animation: false)
    }
    
    func signOut(){
        setRootController(identifierName: "LoginViewController")
    }
    
    // MARK: - Action Method
    
    @IBAction func goToHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }

}


extension BaseViewController: SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
        switch row {
        case .profile:
            let vc=EditProfileVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .cronograma:
            openCalenderView()
        case .notas:
            print("Notes")
            openNotesView()
        case .frequencia:
            print("Frequency")
            openFrequencyView()
        case .financeiro:
            print("Financial")
            openFinancialView()
        case .secretaria:
            print("Secretary")
            openSecretaryView()
        case .divulgacao:
            print("Disclosure")
            openDisclosureView()
        case .conveniencia:
            print("convenience")
            openConcenienceView()
        case .estagios:
            print("Stages")
            openEstagiosView()
        case .ambiente:
            print("Ambient")
            openAmbientView()
        case .suporte:
            print("Support")
            openSupportView()
        case .sugestoes:
            print("Sugestoes")
            openSugestoesView()
        case .sair:
            signOut()
        case .none:
            break
        }
    }
}
