//
//  ViewController.swift
//  AppSchool
//
//  Created by Ahmad on 1/11/18.
//  Copyright © 2018 Ahmad. All rights reserved.

import Foundation
import UIKit
var sidebarView: SidebarView!
var blackScreen: UIView!
class ViewController: UIViewController, UITextFieldDelegate {
    struct User : Codable {
        let RESPONSE: String
        let TOKEN: String
        let MENSAGEMERRO: String
        let MENSAGEMSUCESSO: String
        let STATUS: String
        let TYPE: String
        let NOMEUSER: String?
        let EMAILUSER: String?
    }
    
    @IBOutlet weak var EmailTextView: UITextField!
    @IBOutlet weak var SenhaTextField: UITextField!
    
    var loadIndicator: UIView = UIView()
    
    var window: UIWindow?
    
    @IBAction func doLogin(_ sender: Any) {
        print("doLogin")
        let email = EmailTextView.text
        let senha = SenhaTextField.text
        
        if email == "" {
            UIHelper.showAlertController(uiController: self, message: "Por favor, preencha o e-mail")
            return
        } else if senha == "" {
            UIHelper.showAlertController(uiController: self, message: "Por favor, preencha a senha")
            return
        } else {
            self.loadIndicator = UIHelper.activityIndicator(uiController: self, title: "Carregando")
            doLoginRequest(email: email!, senha: senha!)
//            let viewController: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    func doLoginRequest(email: String, senha: String){
        let postString = """
        {
        \"setEmail\"    :"\(email)",
        \"setSenha\"    :"#Hash('\(senha)', 'MD5')#",
        \"setSistema\"    :"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46",
        \"setUdid\"    :"93C86FG587487CC4876S454GHT13"
        }
        """
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/autenticaracesso")!)
        request.httpMethod = "POST"
        request.addValue("PROD", forHTTPHeaderField: "TAmb")
        
        print(postString)
        
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
                let user = try! decoder.decode(User.self, from: retorno!)
                
                if user.RESPONSE == "200" {
                    DispatchQueue.main.async {
                        UIHelper.stopsIndicator(view: self.loadIndicator)
                        print("ok")
                                self.window = UIWindow(frame:UIScreen.main.bounds)

        
        let viewController: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        self.navigationController?.pushViewController(viewController, animated: false)
                    }
                } else {
                    DispatchQueue.main.async {
                        UIHelper.showAlertController(uiController: self, message: user.MENSAGEMERRO)
                        UIHelper.stopsIndicator(view: self.loadIndicator)
                    }
                }
            }
        }
        task.resume()
    }
    
    @IBAction func goToEsqueciSenha(_ sender: Any) {
        print("doEsqueciSenha")
        let viewController: ForgotPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func goToSuporte(_ sender: Any) {
        let viewController: SupportViewController = self.storyboard?.instantiateViewController(withIdentifier: "SupportVC") as! SupportViewController
        
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
      
        
        EmailTextView?.text = "teste@empresa.com"
        SenhaTextField?.text = "54321"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SenhaTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // ScrollView.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
     //   ScrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
