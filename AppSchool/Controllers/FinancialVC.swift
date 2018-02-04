//
//  FinancialVC.swift
//  AppSchool
//
//  Created by Fasih on 1/26/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class FinancialVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSituacao: UIView!
    @IBOutlet weak var viewLista: UIView!
    @IBOutlet weak var viewTable: UIView!
    
    var loadIndicator: UIView = UIView()
    var financialList = [Financial]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func initializing () {
        self.title = "FINANCEIRO"
        
        callFinancialApi()
    }
    
    func confirmationAlert (obj: Financial) {
        
        let msg = String(format: "%@ \n %@ \n %@", obj.Titulo,obj.Vencimento, obj.CodigoBarras)
        
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {    (action:UIAlertAction!) in
           print("Ok Press")
            
            self.callEMailApi(obj)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {    (action:UIAlertAction!) in
        }))
        
        self.present(alertController, animated: true, completion:{})
    }
    
    func hideList() {
        self.viewTable.isHidden = true
        self.viewLista.isHidden = true
        self.viewSituacao.isHidden = false
    }
    
    // MARK: - API Methods
    
    func callFinancialApi(){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/financeiro")!)
        request.httpMethod = "POST"
        request.addValue("PROD", forHTTPHeaderField: "TAmb")
        request.addValue("A07EAD82EFB8DDC7DD7E07C9DA46FD36", forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                
                UIHelper.showAlertController(uiController: self, message: "Não foi possível conectar ao servidor", title: "Erro")
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            if let data = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if httpStatus?.statusCode == 200 {
                            
                            DispatchQueue.main.async{
                                
                                if jsonResult["RESPONSE"] as? String == "200" {
                                    
                                    let results = jsonResult["CURSO"] as? NSArray!
                                    self.financialList.removeAll()
                                    
                                    for result in results! {
                                        
                                        let listaData = result as! NSDictionary
                                        //let tituloCurso = listaData["TituloCurso"] as! String
                                        let mesResults = listaData["Mes"] as! NSArray
                                        for mesResult in mesResults {
                                            
                                            let mesData = mesResult as! NSDictionary
                                            let mesKeys = mesData.allKeys as! [String]
                                            
                                            for key in mesKeys {
                                                let dataList = mesData[key] as! NSArray
                                                let data = dataList[0] as! NSDictionary
                                                let mesKeys = data.allKeys as! [String]
                                                
                                                let listObj = Financial()
                                                if(mesKeys.contains("CodigoBarras")){
                                                    listObj.CodigoBarras = data["CodigoBarras"] as! String
                                                }
                                                
                                                listObj.IdTitulo = data["IdTitulo"] as! String
                                                listObj.StatusPagto = data["StatusPagto"] as! String
                                                listObj.Titulo = data["Titulo"] as! String
                                                listObj.Valor = data["Valor"] as! String
                                                listObj.Vencimento = data["Vencimento"] as! String
                                                    
                                                self.financialList.append(listObj)
                                            }
                                        }
                                    }
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            UIHelper.stopsIndicator(view: self.loadIndicator)
                        }
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        UIHelper.stopsIndicator(view: self.loadIndicator)
                    }
                }
            } else if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    UIHelper.stopsIndicator(view: self.loadIndicator)
                }
            }
            
        }
        
        task.resume()
    }
    
    func callEMailApi(_ obj:Financial){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        let postString = """
        {
        \"setIdTitulo\"    :"\(obj.IdTitulo)"
        }
        """
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/sendmail")!)
        request.httpMethod = "POST"
        request.addValue("PROD", forHTTPHeaderField: "TAmb")
        request.addValue("A07EAD82EFB8DDC7DD7E07C9DA46FD36", forHTTPHeaderField: "token")
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                
                UIHelper.showAlertController(uiController: self, message: "Não foi possível conectar ao servidor", title: "Erro")
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            if let data = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if httpStatus?.statusCode == 200 {
                            
                            DispatchQueue.main.async{
                                
                                if jsonResult["RESPONSE"] as? String == "200" {
                                    UtilityHelper.showOKAlert("", message: jsonResult["MENSAGEMSUCESSO"] as! String, target: self)
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            UIHelper.stopsIndicator(view: self.loadIndicator)
                        }
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        UIHelper.stopsIndicator(view: self.loadIndicator)
                    }
                }
            } else if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    UIHelper.stopsIndicator(view: self.loadIndicator)
                }
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
        
        return 48
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.financialList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "FinancialCell", for: indexPath) as! FinancialCell
        
        // Configure the cell...
        let object = self.financialList[indexPath.row]
        cell.obj = object
        
        cell.btnUpload.addTarget(self, action: #selector(actionShowPopup(_:)), for: .touchUpInside)
        cell.btnUpload.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        hideList()
    }
    
    // MARK: - Action Methods
    
    @IBAction func actionShowList(_ sender: Any) {
        self.viewTable.isHidden = false
        self.viewLista.isHidden = false
        self.viewSituacao.isHidden = true
    }
    
    @IBAction func actionRefresh(_ sender: UIButton) {
        callFinancialApi()
        hideList()
    }
    
    @IBAction func actionShowPopup(_ sender: UIButton) {
        
        let btnsend: UIButton = sender
        let object = self.financialList[btnsend.tag]
        
        confirmationAlert(obj: object)
    }
}
