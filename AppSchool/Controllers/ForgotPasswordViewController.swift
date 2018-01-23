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
       
        let RESPONSE: String
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
    
    func doForgotPasswordRequest(email: String){
        let postString = """
        {
        \"setEmail\"    :"\(email)",
        \"setSistema\"    :"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46",
        \"setUdid\"    :"93C86FG587487CC4876S454GHT13"
        }
        """
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/redefinirsenha")!)
        request.httpMethod = "POST"
        request.addValue("PROD", forHTTPHeaderField: "TAmb")
        
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                
                UIHelper.showAlertController(uiController: self, message: "Não foi possível conectar ao servidor", title: "Erro")
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
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let popupVC = storyboard.instantiateViewController(withIdentifier: "successForgottenPasswordViewController") as! SuccessForgottenPasswordViewController
                    popupVC.modalPresentationStyle = .popover
                    popupVC.preferredContentSize = CGSize(width: 300, height: 300)
                    
                    popupVC.stringPassed = responseStruct.MENSAGEMSUCESSO!
                    if responseStruct.RESPONSE != "200" {
                        popupVC.stringPassed = responseStruct.MENSAGEMERRO!
                    }
                    popupVC.status = responseStruct.STATUS
                    
                    let pVC = popupVC.popoverPresentationController
                    pVC?.permittedArrowDirections = .any
                    pVC?.delegate = self
                    pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
                   // self.present(popupVC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(popupVC, animated: true)
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
            self.loadIndicator =  UIHelper.activityIndicator(uiController: self, title: "Carregando")
            doForgotPasswordRequest(email: email!)
        }
    }
    
}
