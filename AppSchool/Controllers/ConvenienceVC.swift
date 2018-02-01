//
//  ConvenienceVC.swift
//  AppSchool
//
//  Created by Fasih on 1/30/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class ConvenienceVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var loadIndicator: UIView = UIView()
    var convenienceList = [NotesList]()

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
        self.title = "CONVENIÊNCIA"
        
        self.setupRefreshControl()
        callConvenienceApi()
    }

    func setupRefreshControl() {
        
        refreshControl.tintColor = UIColor.black
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(pullRefreshList), for: UIControlEvents.valueChanged)
    }
    
    @objc func pullRefreshList(refreshC: UIRefreshControl) {
        
        // Do something
        
        if (UtilityHelper.isNetworkAvailable() == true) {
            self.callConvenienceApi()
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
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.convenienceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ConvenCell", for: indexPath) as! ConvenienceCell
        
        // Configure the cell...
        let obj = self.convenienceList[indexPath.row]
        cell.lblTitle.text = obj.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let object = self.convenienceList[indexPath.row]
        UIApplication.shared.openURL(URL(string: object.value)!)
    }
    
    // MARK: - API Methods
    
    func callConvenienceApi(){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/conveniencia")!)
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
                                    
                                    let results = jsonResult["CONVENIENCIA"] as? NSArray!
                                    
                                    self.convenienceList.removeAll()
                                    
                                    for result in results! {
                                        
                                        let listData = result as! NSDictionary
                                        let keys = listData.allKeys as! [String]
                                        
                                        for key in keys {
                                            
                                            let value = listData[key] as! String
                                            
                                            let listObj = NotesList()
                                            listObj.name = key
                                            listObj.value = value
                                            
                                            self.convenienceList.append(listObj)
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


}
