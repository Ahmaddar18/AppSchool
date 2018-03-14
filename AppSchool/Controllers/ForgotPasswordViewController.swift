//
//  ForgotPasswordViewController.swift
//  AppSchool
//
//  Created by Mayck Xavier on 28/11/17.
//  Copyright © 2017 Mayck Xavier. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    struct Response : Codable {
       
        let RESPONSE: Int
        let MENSAGEMERRO: String?
        let STATUS: String
        let MENSAGEMSUCESSO: String?
        let TYPE: String
    }
    
    @IBOutlet weak var mainText: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    
    var loadIndicator: UIView = UIView()
    var strLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hides keyboard automatically
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        UIHelper.addTFLeftPadding(width: 10, textField: emailTextField)
        navigationHeaderStyling()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goBack), name: Notification.Name(ForgotBackNotification), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainText.setContentOffset(CGPoint.zero, animated: false)
    }
    
    // MARK: - Helper
    
    func navigationHeaderStyling () {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor.orangeColor()
        self.navigationController?.navigationBar.tintColor=UIColor.white
        
        self.navigationItem.title = "Recuperar Senha"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Voltar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func doForgotPasswordRequest(email: String){
        let postString = """
        {
        \"setEmail\"    :"\(email)",
        \"setSistema\"    :"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46",
        \"setUdid\"    :"93C86FG587487CC4876S454GHT13"
        }
        """
        
        var request = URLRequest(url: URL(string: API_Base_Path+"redefinirsenha")!)
        request.httpMethod = "POST"
        request.addValue(API_HEADER, forHTTPHeaderField: "TAmb")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                
                UIHelper.showAlertController(uiController: self, message: "Não foi possível conectar ao servidor", title: "Erro")
                UIHelper.stopsIndicator(view: self.loadIndicator)
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            print("httpStatus = \(String(describing: httpStatus))")
            if httpStatus?.statusCode == 200 {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                
                let retorno = responseString?.data(using: .utf8)!
                
                let decoder = JSONDecoder()
                let responseStruct = try! decoder.decode(Response.self, from: retorno!)
                
                DispatchQueue.main.async {
                    
                    var msg: String = ""
                    
                    if responseStruct.RESPONSE != 200 {
                        msg = responseStruct.MENSAGEMERRO!
                        SuccessForgottenPasswordViewController.shared.showForgotSuccessView(view: self.view, childView: SuccessForgottenPasswordViewController.shared.view, mesg: msg, status: false)
                    }else{
                        
                        msg = responseStruct.MENSAGEMSUCESSO!
                        SuccessForgottenPasswordViewController.shared.showForgotSuccessView(view: self.view, childView: SuccessForgottenPasswordViewController.shared.view, mesg: msg, status: true)
                    }
                    
                    
                    
                    UIHelper.stopsIndicator(view: self.loadIndicator)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Action Methods
    
    @IBAction func doForgotPassword(_ sender: Any) {
        let email = emailTextField.text
        if email == "" {
            UIHelper.showAlertController(uiController: self, message: "Por favor, preencha 0 e-mail")
            return
        } else {
            self.loadIndicator =  UIHelper.activityIndicator(view: self.view, title: "Carregando")
            doForgotPasswordRequest(email: email!)
        }
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: false)
    }
    
}
