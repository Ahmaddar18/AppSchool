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
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var viewTable: UIView!
    
    var loadIndicator: UIView = UIView()
    var financialList = [Financial]()
    var isListDisplaed: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializing()
        
        showList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func initializing () {
        
        self.navigationController?.navigationBar.tintColor=UIColor.white
        //self.title = "FINANCEIRO"
        
        callFinancialApi()
    }
    
    func confirmationAlert (obj: Financial) {
        
        let msg = String(format: "%@ \n %@ \n %@ \n %@", "Enviar Boleto de",obj.Vencimento,"Código de Barras",obj.CodigoBarras) //obj.Titulo
        
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
        self.imgDropDown.isHidden = false
        self.isListDisplaed = false
    }
    
    func showList() {
        self.isListDisplaed = true
        self.viewTable.isHidden = false
        self.imgDropDown.isHidden = true
    }
    
    // MARK: - API Methods
    
    func callFinancialApi(){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        let urlStr = API_Base_Path+"financeiro"
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "POST"
        request.addValue(API_HEADER, forHTTPHeaderField: "TAmb")
        request.addValue(AppDel.getUserToken(), forHTTPHeaderField: "token")
        
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
                                
                                if jsonResult["RESPONSE"] as? Int == 200 {
                                    
                                    let results = jsonResult["CURSO"] as? NSArray!
                                    self.financialList.removeAll()
                                    
                                    if results == nil {
                                        return
                                    }
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
                                                
                                                listObj.IdTitulo = String(format:"%d",data["IdTitulo"] as AnyObject as! CVarArg)
                                                listObj.StatusPagto = data["StatusPagto"] as! String
                                                listObj.Titulo = data["Titulo"] as! String
                                                listObj.Valor = String(format:"%d",data["Valor"] as AnyObject as! CVarArg)
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
        \"setIdTitulo\":"\(obj.IdTitulo)"
        }
        """
        
        let urlStr = API_Base_Path+"sendmail"
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "POST"
        request.addValue(API_HEADER, forHTTPHeaderField: "TAmb")
        request.addValue(AppDel.getUserToken(), forHTTPHeaderField: "token")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "accept-language")
        
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
                                
                                if jsonResult["RESPONSE"] as? Int == 200 {
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
        
        if indexPath.row == 0 {
            cell.lblLine.isHidden = false
        }else{
            cell.lblLine.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        hideList()
    }
    
    // MARK: - Action Methods
    
    @IBAction func actionShowList(_ sender: Any) {
        
        if isListDisplaed {
            callFinancialApi()
            hideList()
        }else{
            self.showList()
        }
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
