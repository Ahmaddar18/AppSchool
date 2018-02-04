//
//  AmbienceVC.swift
//  AppSchool
//
//  Created by Fasih on 1/30/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class AmbienceVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var loadIndicator: UIView = UIView()
    var anbienceList = [NotesList]()

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
        self.title = "AMBIENTE EAD"
        
        self.setupRefreshControl()
        callAmbienteeadApi()
    }
    
    func setupRefreshControl() {
        
        refreshControl.tintColor = UIColor.black
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(pullRefreshList), for: UIControlEvents.valueChanged)
    }
    
    @objc func pullRefreshList(refreshC: UIRefreshControl) {
        
        // Do something
        
        if (UtilityHelper.isNetworkAvailable() == true) {
            self.callAmbienteeadApi()
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
        
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.anbienceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "WebCell", for: indexPath) as! WebCellView
        
        // Configure the cell...
        let obj = self.anbienceList[indexPath.row]
        cell.btnWeb.titleLabel?.text = obj.name
        cell.underline()
        
        cell.btnWeb.addTarget(self, action: #selector(actionOpenWeb(_:)), for: .touchUpInside)
        cell.btnWeb.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - API Methods
    
    func callAmbienteeadApi(){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/ambienteead")!)
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
                                    
                                    let results = jsonResult["EAD"] as? NSArray!
                                    
                                    self.anbienceList.removeAll()
                                    
                                    for result in results! {
                                        
                                        let listData = result as! NSDictionary
                                        let strTitulo = listData["Titulo"] as! String
                                        let strUrlEad = listData["UrlEad"] as! String
                                        
                                        let listObj = NotesList()
                                        listObj.name = strTitulo
                                        listObj.value = strUrlEad
                                        
                                        self.anbienceList.append(listObj)
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
        let object = self.anbienceList[btnsendtag.tag]
        UIApplication.shared.openURL(URL(string: String(format: "%@",object.value))!)
    }

}
