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
        
        childView.frame = CGRect(x: 0, y: 65, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(childView)
        
        //successMessageTextView.text = mesg
        
        if isLoggedin {
            btnPress.isHidden = true
            lblCode.isHidden = false
            lblCode.text = String(format: "Chamado: %@",code)
            lblMsgH.constant = 28
        }else{
            lblCode.isHidden = false
            lblCodeY.constant = 20
        }
    }
    
    func removeLoadingAnimation(view: UIView, childView:UIView){
        
        childView.removeFromSuperview()
    }
    
    // MARK: - Action Methods
    
    @IBAction func dismissViewController(_ sender: Any) {
       // dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: false)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    

}
