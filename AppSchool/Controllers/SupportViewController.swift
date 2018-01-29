//
//  SupportViewController.swift
//  AppSchool
//
//  Created by Mayck Xavier on 26/11/17.
//  Copyright © 2017 Mayck Xavier. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController, UITextViewDelegate {
    
    struct Response : Codable {
        
        let RESPONSE: String
        let MENSAGEMERRO: String?
        let STATUS: String
        let MENSAGEMSUCESSO: String?
        let TYPE: String
    }
   
    var loadIndicator: UIView = UIView()
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inittextView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.textColor == UIColor.lightGray {
            messageTextView.text = nil
            messageTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text.isEmpty {
            messageTextView.text = "Digite a sua mensagem"
            messageTextView.textColor = UIColor.lightGray
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
        
        if message == "" || message == "Digite a sua mensagem" {
            UIHelper.showAlertController(uiController: self, message: "Por favor, a mensagem para o suporte")
            return false
        }
        
        return true
    }
    
    func inittextView(){
        messageTextView.text = "Digite a sua mensagem"
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.cornerRadius = 5
        messageTextView.textColor = UIColor.lightGray
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func submitSupportCall(_ sender: Any) {
        if isDataValid() {
            
           loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Enviando dados")
            
            let email = emailTextView.text!
            let message = messageTextView.text!
            
            let postString = """
            {
            \"setEmail\"    :"\(email)",
            \"setMensagem\" :"\(message)",
            }
            """
            
            print(postString)
            var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/suportechamado")!)
            request.httpMethod = "POST"
            request.addValue("PROD", forHTTPHeaderField: "TAmb")
            
            
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
                    
                    var titleAlert = "Erro"
                    var messageAlert = responseStruct.MENSAGEMERRO
                    
                    if responseStruct.RESPONSE == "200" {
                        titleAlert = "Informação"
                        messageAlert = responseStruct.MENSAGEMSUCESSO
                    }
                    
                    DispatchQueue.main.async {
                        UIHelper.showAlertController(uiController: self, message: messageAlert!, title: titleAlert)
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
