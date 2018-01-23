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
    
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        successMessageTextView.text? = "Envio de dados realizado com sucesso. Conforme orientações no e-mail efetue seu acesso clicando no botão abaixo"
        if status == "ERRO" {
            successImageView.image = UIImage(named: "error-96.png")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
       // dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    

}
