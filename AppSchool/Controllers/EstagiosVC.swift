
//
//  EstagiosVC.swift
//  AppSchool
//
//  Created by Fasih on 1/30/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class EstagiosVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var loadIndicator: UIView = UIView()
    var estagiosList = [NotesList]()

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
        //self.title = "ESTÁGIOS"
        
        self.setupRefreshControl()
        
        callEstagioApi()
        
    }
    
    func setupRefreshControl() {
        
        refreshControl.tintColor = UIColor.orangeColor()
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(pullRefreshList), for: UIControlEvents.valueChanged)
    }
    
    @objc func pullRefreshList(refreshC: UIRefreshControl) {
        
        // Do something
        
        if (UtilityHelper.isNetworkAvailable() == true) {
            self.callEstagioApi()
        }else{
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.estagiosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "WebCell", for: indexPath) as! WebCellView
        
        // Configure the cell...
        let obj = self.estagiosList[indexPath.row]
        cell.btnWeb.setTitle(obj.name,for: .normal)
        //cell.btnWeb.titleLabel?.text = obj.name
        //cell.underline()
        
        if (indexPath.row == 0){
            cell.lblTopLine.isHidden = false
        }else{
            cell.lblTopLine.isHidden = true
        }
        
        cell.btnWeb.addTarget(self, action: #selector(actionOpenWeb(_:)), for: .touchUpInside)
        cell.btnWeb.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - API Methods
    
    func callEstagioApi(){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        let urlStr = API_Base_Path+"estagio"
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "POST"
        request.addValue(API_HEADER, forHTTPHeaderField: "TAmb")
        request.addValue(AppDel.getUserToken(), forHTTPHeaderField: "token")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "accept-language")
        
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
                                    
                                    let results = jsonResult["ESTAGIO"] as? NSArray!
                                    
                                    self.estagiosList.removeAll()
                                    
                                    if results == nil {
                                        return
                                    }
                                    
                                    for result in results! {
                                        
                                        let listData = result as! NSDictionary
                                        let keys = listData.allKeys as! [String]
                                        
                                        for key in keys {
                                            
                                            let value = listData[key] as! String
                                            
                                            let listObj = NotesList()
                                            listObj.name = key
                                            listObj.value = value
                                            
                                            self.estagiosList.append(listObj)
                                        }
                                        
                                    }
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            UIHelper.stopsIndicator(view: self.loadIndicator)
                            self.refreshControl.endRefreshing()
                        }
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        UIHelper.stopsIndicator(view: self.loadIndicator)
                        self.refreshControl.endRefreshing()
                    }
                }
            } else if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    UIHelper.stopsIndicator(view: self.loadIndicator)
                    self.refreshControl.endRefreshing()
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Action Methods
    
    @IBAction func actionOpenWeb(_ sender: UIButton) {
        let btnsendtag: UIButton = sender
        let object = self.estagiosList[btnsendtag.tag]
        UIApplication.shared.openURL(URL(string: String(format: "%@",object.value))!)
    }

}
