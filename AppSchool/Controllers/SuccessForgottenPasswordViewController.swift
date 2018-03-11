//
//  SuccessForgottenPasswordViewController.swift
//  AppSchool
//
//  Created by Mayck Xavier on 14/12/17.
//  Copyright © 2017 Mayck Xavier. All rights reserved.
//

import UIKit

class SuccessForgottenPasswordViewController: UIViewController {

    var stringPassed: String = ""
    var status: String = ""
    
    @IBOutlet weak var successMessageTextView: UITextView!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var lblMsgText: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnPress: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblMsgH: NSLayoutConstraint!
    @IBOutlet weak var lblCodeY: NSLayoutConstraint!
    @IBOutlet weak var lblMsgY: NSLayoutConstraint!
    
    static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "successForgottenPasswordVC") as! SuccessForgottenPasswordViewController
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        //successMessageTextView.text? = "Envio de dados realizado com sucesso. Conforme orientações no e-mail efetue seu acesso clicando no botão abaixo"
        
        lblMsgText.text? = stringPassed
        
        if status == "ERRO" {
            successImageView.image = UIImage(named: "ic_action_close")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSuccessView(view: UIView, childView: UIView, mesg: String, isLoggedin: Bool, code: String){
        
        if isLoggedin {
            childView.frame = CGRect(x: 0, y: 65+66, width: view.frame.size.width, height: view.frame.size.height-200)
            view.addSubview(childView)
            
            btnPress.isHidden = true
            lblCode.isHidden = true
            //lblMsgH.constant = 35
            lblMsgText.text = mesg
            if code.count > 0 {
                lblCode.isHidden = false
                lblCode.text = String(format: "Chamado: %@",code)
                lblCodeY.constant = 70
            }
            
        }else{
            childView.frame = CGRect(x: 0, y: 65, width: view.frame.size.width, height: view.frame.size.height-65)
            view.addSubview(childView)
            
            lblMsgText.text = mesg
            if code.count > 0 {
                lblCode.isHidden = false
                btnPress.isHidden = false
                lblCode.text = String(format: "Chamado: %@",code)
                lblCodeY.constant = 70
            }
        }
    }
    
    func removeLoadingAnimation(view: UIView, childView:UIView){
        
        childView.removeFromSuperview()
    }
    
    func showForgotSuccessView(view: UIView, childView: UIView, mesg: String, status: Bool){
        
        childView.frame = CGRect(x: 0, y: 65, width: view.frame.size.width, height: view.frame.size.height-65)
        view.addSubview(childView)
        lblMsgY.constant = 30
        lblMsgText.text = mesg
        
        if !status {
            successImageView.image = UIImage(named: "ic_action_close")
        }else{
            successImageView.image = UIImage(named: "ic_action_confirm")
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func dismissViewController(_ sender: Any) {
       // dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: false)
        //self.navigationController?.popToRootViewController(animated: false)
        
        //self.view.removeFromSuperview()
        NotificationCenter.default.post(name: Notification.Name(ForgotBackNotification), object: nil)
    }
    
    

}
