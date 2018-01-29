//
//  SecretaryVC.swift
//  AppSchool
//
//  Created by Fasih on 1/26/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class SecretaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var optionsPickerView: UIPickerView!
    @IBOutlet weak var tfOption: UITextField!
    
    var loadIndicator: UIView = UIView()
    var secretaryList = [NotesList]()
    var periodoList = [NotesList]()

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
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.title = "SECRETARIA ON-LINE"
        
        self.tfOption.inputView = optionsPickerView
        callApi()
    }
    
    func showOptionView(){
        
        self.tfOption.text = ""
        let frame = CGRect(x: 0, y: 115, width: self.view.frame.size.width, height: self.view.frame.size.height-115)
        viewOptions.frame = frame
        AppDel.window?.addSubview(viewOptions)
        
        btnBack.isHidden = false
    }
    
    // MARK: - UIPickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return periodoList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let obj = periodoList[row]
        return obj.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let obj = periodoList[row]
        self.tfOption.text = obj.name
        self.view.reloadInputViews()
    }
    
    // MARK: - API Methods
    
    func callApi(){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/secretariaonlinedocumento")!)
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
                                    
                                    let results = jsonResult["FORMULARIO"] as? NSArray!
                                    
                                    for result in results! {
                                        
                                        let listaData = result as! NSDictionary
                                        let documentoResults = listaData["ListaDocumento"] as! NSArray
                                        for documentoResult in documentoResults {
                                            
                                            let data = documentoResult as! NSDictionary
                                            let keys = data.allKeys as! [String]
                                            
                                            for key in keys {
                                                
                                                let listResults = data[key] as! NSArray
                                                let listData = listResults[0] as! NSDictionary
                                                let idDoc = listData["idDoc"] as! Int
                                                
                                                let listObj = NotesList()
                                                listObj.name = key
                                                listObj.value = String(idDoc)
                                                
                                                self.secretaryList.append(listObj)
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
    
    func callPeriodoApi(docId: String){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.viewOptions, title: "Carregando")
        //self.viewOptions.superview?.bringSubview(toFront: loadIndicator)
        //self.loadIndicator.superview?.bringSubview(toFront: viewOptions)
        
        let postString = """
        {
        \"setIdDoc\"    :"\(docId)"
        }
        """
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/periodoletivo")!)
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
                                    
                                    self.periodoList.removeAll()
                                    
                                    let results = jsonResult["PERIODO"] as? NSArray!
                                    
                                    for result in results! {
                                        
                                        let listaData = result as! NSDictionary
                                        let value = listaData.allKeys as! [String]
                                        
                                        for val in value {
                                            
                                            let data = listaData[val] as? NSArray!
                                            let reslut = data![0] as! NSDictionary
                                            
                                            let resultValue = reslut["valor"] as! String
                                            
                                            let listObj = NotesList()
                                            listObj.name = val
                                            listObj.value = resultValue
                                            
                                            self.periodoList.append(listObj)   
                                        }
                                    }
                                    // reload picker view
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
    
    // MARK: - Action Methods
    
    @IBAction func actionHideView(_ sender: UIButton) {
        viewOptions.removeFromSuperview()
        btnBack.isHidden = true
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.secretaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "SecCell", for: indexPath) as! SecretrayCellView
        
        // Configure the cell...
        let obj = self.secretaryList[indexPath.row]
        
        cell.lblTitle.text = obj.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        showOptionView()
        let obj = self.secretaryList[indexPath.row]
        callPeriodoApi(docId: obj.value)
    }
    
}