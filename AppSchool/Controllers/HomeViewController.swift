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

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCross: UIButton!
    
    var loadIndicator: UIView = UIView()
    var window: UIWindow?
    var dict: Dictionary = [String: String]()
    var allResults = [Home]()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        loadDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - API Methods
    
    func loadDataFromServer(){
       
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
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
                let resultList = siteData.NOTICIA
                
                for item in resultList {
                    let order = Home()
                    
                    if(item.Imagem != nil){
                        order.Imagem = item.Imagem!
                    }
                    if(item.ImagemLegenda != nil){
                        order.ImagemLegenda = item.ImagemLegenda!
                    }
                    if(item.LinkDestino != nil){
                        order.LinkDestino = item.LinkDestino!
                    }
                    if(item.LinkTexto != nil){
                        order.LinkTexto = item.LinkTexto!
                    }
                    if(item.TituloNews != nil){
                        order.TituloNews = item.TituloNews!
                    }
                    
                    self.allResults.append(order)
                }
                
            } catch let jsonErr {
                print("error in parsing",jsonErr)
            }
         
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.btnCross.isHidden = false
                UIHelper.stopsIndicator(view: self.loadIndicator)
            }
            
        }
        
        task.resume()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var rowHeight = 280
        
        let obj = self.allResults[indexPath.row]
        
        if (obj.Imagem == "") {
            rowHeight = rowHeight - 130
        }
        if (obj.LinkDestino == "") {
            rowHeight = rowHeight - 30
        }
        if (obj.ImagemLegenda == "") {
            rowHeight = rowHeight - 22
        }
        
        print("row height:",rowHeight)
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCellView
        
        // Configure the cell...
        
        let object = self.allResults[indexPath.row]
        cell.obj = object
        
        cell.btnLink.titleLabel?.text = object.LinkTexto
        cell.btnLink.addTarget(self, action: #selector(actionOpenWeb(_:)), for: .touchUpInside)
        cell.btnLink.tag = indexPath.row
        cell.underline()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Action Methods
    
    @IBAction func actionOpenWeb(_ sender: UIButton) {
        let btnsendtag: UIButton = sender
        let object = self.allResults[btnsendtag.tag]
        UIApplication.shared.openURL(URL(string: String(format: "http://%@",object.LinkDestino))!)
    }
}

