//
//  SupportInnerVC.swift
//  AppSchool
//
//  Created by Fasih on 2/1/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class SupportInnerVC: BaseViewController, UITextViewDelegate {
    
    struct Response : Codable {
        
        let RESPONSE: Int
        let MENSAGEMERRO: String?
        let STATUS: String
        let MENSAGEMSUCESSO: String?
        let TYPE: String
        let NUMCHAMADO: Int
    }
    
    var loadIndicator: UIView = UIView()
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var viewHeaderY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inittextView()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor.orangeColor()
        self.navigationController?.navigationBar.tintColor=UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.textColor == UIColor.init(red: 79/255, green: 87/255, blue: 95/255, alpha: 1.0) {
            messageTextView.text = nil
            messageTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text.isEmpty {
            messageTextView.text = SupportMsg
            messageTextView.textColor = UIColor.init(red: 79/255, green: 87/255, blue: 95/255, alpha: 1.0)
        }
    }
    
    // MARK: - Helper
    
    func isDataValid() -> Bool{
        let email = emailTextView.text
        let message = messageTextView.text
        
        if email == "" {
            UIHelper.showAlertController(uiController: self, message: "Por favor, preencha o e-mail")
            return false
        }
        
        if message == "" || message == SupportMsg {
            UIHelper.showAlertController(uiController: self, message: "Por favor, a mensagem para o suporte")
            return false
        }
        
        return true
    }
    
    func inittextView(){
        messageTextView.text = SupportMsg
        messageTextView.textColor = UIColor.init(red: 79/255, green: 87/255, blue: 95/255, alpha: 1.0)
        
        UIHelper.addTFLeftPadding(width: 10, textField: emailTextView)
        messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let dictUser = USER_DEFAULTS.value(forKey: LOGGEDIN_USER_INFO) as? NSDictionary
        emailTextView.text = (dictUser?[EMAIL] as? String)!
        
        if ConstantDevices.IS_IPHONE_X {
            self.viewHeaderY.constant = 93
        }
    }
    
    
    @IBAction func submitSupportCall(_ sender: Any) {
        
        if isDataValid() {
            
            loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Enviando dados")
            
            let email = emailTextView.text!
            let message = messageTextView.text!
            
            let postString = """
            {
            \"setEmail\"    :"\(email)",
            \"setMensagem\" :"\(message)"
            }
            """
            
            print(postString)
            
            let urlLink = API_Base_Path+"suporteinterno"
            
            var request = URLRequest(url: URL(string: urlLink)!)
            request.httpMethod = "POST"
            request.addValue(API_HEADER, forHTTPHeaderField: "TAmb")
            request.addValue(AppDel.getUserToken(), forHTTPHeaderField: "token")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    
                    
                    UIHelper.showAlertController(uiController: self, message: "Não foi possível conectar ao servidor")
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
                    
                    //var titleAlert = "Erro"
                    var messageAlert = responseStruct.MENSAGEMERRO
                    
                    if responseStruct.RESPONSE == 200 {
                        //titleAlert = "Informação"
                        messageAlert = responseStruct.MENSAGEMSUCESSO
                    }
                    
                    DispatchQueue.main.async {
                        
                        SuccessForgottenPasswordViewController.shared.showSuccessView(view: self.view, childView: SuccessForgottenPasswordViewController.shared.view, mesg: messageAlert!, isLoggedin: true, code: String(format: "%d",responseStruct.NUMCHAMADO))
                        
                        UIHelper.stopsIndicator(view: self.loadIndicator)
                    }
                } else {
                    DispatchQueue.main.async {
                        UIHelper.showAlertController(uiController: self, message: "Chamado não foi aberto, favor refazer a operação")
                        UIHelper.stopsIndicator(view: self.loadIndicator)
                    }
                }
            }
            task.resume()
        }
    }
    
}
