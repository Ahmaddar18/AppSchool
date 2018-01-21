//
//  HomeViewController.swift
//  AppSchool
//
//  Created by Ahmad on 1/13/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

struct webData : Decodable {
    let REPONSE : Int?
    let MENSAGEMERRO : String?
    let STATUS : String?
    let TYPE : String?
    let NOTICIA : [nestedData]
}
struct nestedData : Decodable {
    let Imagem : String?
    let LinkTexto : String?
    let LinkDestino : String?
    let ImagemLegenda : String?
    let TituloNews : String?
}
class HomeViewController: UIViewController {
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
    @IBOutlet weak var imgView: UIImageView!
    var loadIndicator: UIView = UIView()
    var window: UIWindow?
    var dict: Dictionary = [String: String]()
    var mylength:Int = 0
    var dictionaries = [[String: String]]()
    func calender()
    {
        let viewController: CalenderVC = self.storyboard?.instantiateViewController(withIdentifier: "calenderVC") as! CalenderVC
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    var sidebarView: SidebarView!
    var blackScreen: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    func initialSettings()
    {
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
        loadDataFromServer()
    }
    func loadDataFromServer(){
       
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/bemvindohome")!)
        request.httpMethod = "POST"
        request.addValue("PROD", forHTTPHeaderField: "TAmb")
        request.addValue("A07EAD82EFB8DDC7DD7E07C9DA46FD36", forHTTPHeaderField: "token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                
                UIHelper.showAlertController(uiController: self, message: "Não foi possível conectar ao servidor", title: "Erro")
                return
            }
            let httpStatus = response as? HTTPURLResponse
            print("httpStatus = \(String(describing: httpStatus))")
            do {
                let siteData = try JSONDecoder().decode(webData.self, from: data)
                print(" Worked")
                print("description = ",siteData.TYPE!)
                print("fuck you matder chod", siteData.NOTICIA[0].Imagem!)
                for jsonData in siteData.NOTICIA
                {
                     var dictionary1 : [String: String] = [:]
                    if(jsonData.Imagem != nil)
                    {
                     dictionary1["Imagem"] = jsonData.Imagem!
                    }
                    if(jsonData.ImagemLegenda != nil)
                    {
                        dictionary1["ImagemLegenda"] = jsonData.ImagemLegenda!
                    }
                    if(jsonData.LinkDestino != nil)
                    {
                        dictionary1["LinkDestino"] = jsonData.LinkDestino!
                    }
                    if(jsonData.LinkTexto != nil)
                    {
                        dictionary1["LinkTexto"] = jsonData.LinkTexto!
                    }
                    if(jsonData.TituloNews != nil)
                    {
                        dictionary1["TituloNews"] = jsonData.TituloNews!
                    }
                   
                 //   dictionary1.add("Imagem",jsonData.Imagem)
                    self.dictionaries.append(dictionary1)
                }
                
            } catch let jsonErr {
                print("error in parsing",jsonErr)
            }
            self.mylength = self.dictionaries.count
            var index:Int = 0
            while index < self.mylength
            {
                if(self.dictionaries[index]["Imagem"] != nil)
                {
                    print("dict values are", self.dictionaries[index]["Imagem"]!)
                  //  let dataString:String = self.dictionaries[index]["Imagem"]!
                  //  let imgData = NSData(contentsOfFile:dataString)
                    self.imgView.image = UIImage(data:(self.dictionaries[index]["Imagem"] as! Data?)!)
                }
                if(self.dictionaries[index]["ImagemLegenda"] != nil)
                {
                    print("dict values are", self.dictionaries[index]["ImagemLegenda"]!)
                }
                if(self.dictionaries[index]["LinkDestino"] != nil)
                {
                    print("dict values are", self.dictionaries[index]["LinkDestino"]!)
                }
                if(self.dictionaries[index]["LinkTexto"] != nil)
                {
                    print("dict values are", self.dictionaries[index]["LinkTexto"]!)
                }
                if(self.dictionaries[index]["TituloNews"] != nil)
                {
                   print("dict values are", self.dictionaries[index]["TituloNews"]!)
                }
                
                index+=1
            }
//            let httpStatus = response as? HTTPURLResponse
//            print("httpStatus = \(String(describing: httpStatus))")
//            if httpStatus?.statusCode == 200 {
//                let responseString = String(data: data, encoding: .utf8)
//                print("responseString = \(String(describing: responseString))")
//
//
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print(json)
//                    } catch {
//                        print(error)
//                    }
            
               
                
//                if user.RESPONSE == "200" {
//                    DispatchQueue.main.async {
//                        UIHelper.stopsIndicator(view: self.loadIndicator)
//                        print("ok")
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        UIHelper.showAlertController(uiController: self, message: user.MENSAGEMERRO)
//                        UIHelper.stopsIndicator(view: self.loadIndicator)
//                    }
//                }
            //}
        }
        task.resume()
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

