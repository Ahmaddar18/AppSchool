//
//  HomeViewController.swift
//  AppSchool
//
//  Created by Ahmad on 1/13/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit
class HomeViewController: UIViewController {
     func calender() {
        let viewController: CalenderVC = self.storyboard?.instantiateViewController(withIdentifier: "calenderVC") as! CalenderVC
        
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    var sidebarView: SidebarView!
    var blackScreen: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor.blue
        self.title = "Home"
        
        let btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(btnMenuAction))
        btnMenu.tintColor=UIColor(red: 54/255, green: 55/255, blue: 56/255, alpha: 1.0)
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

    @objc func btnMenuAction() {
        blackScreen.isHidden=false
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 250, height: self.sidebarView.frame.height)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 func signOut()
 {
    print("signout")
    
    self.navigationController?.popViewController(animated: false)
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//    self.present(newViewController, animated: true, completion: nil)
 }
}

extension HomeViewController: SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
        switch row {
        case .cronograma:
            let vc=EditProfileVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .notas:
            calender()
        case .frequencia:
            print("Contact")
        case .financeiro:
            print("Settings")
        case .secretaria:
            print("History")
        case .divulgacao:
            print("Help")
        case .conveniencia:
            print("conveniencia")
        case .estagios:
            print("estagios")
        case .ambiente:
            print("ambiente")
        case .suporte:
            print("suporte")
        case .sair:
            signOut()
        case .none:
            break
            //        default:  //Default will never be executed
            //            break
        }
    }
}

