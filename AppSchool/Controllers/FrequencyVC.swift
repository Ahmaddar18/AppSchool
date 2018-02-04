//
//  FrequencyVC.swift
//  AppSchool
//
//  Created by Fasih on 1/26/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class FrequencyVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var loadIndicator: UIView = UIView()
    var frequencyList = [NotesModel]()
    
    var refreshControl = UIRefreshControl()

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
        self.title = "FREQUÊNCIA"
        
        callApi()
        
        self.setupRefreshControl()
    }
    
    func setupRefreshControl() {
        
        refreshControl.tintColor = UIColor.black
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(pullRefreshList), for: UIControlEvents.valueChanged)
    }
    
    @objc func pullRefreshList(refreshC: UIRefreshControl) {
        
        // Do something
        
        if (UtilityHelper.isNetworkAvailable() == true) {
            self.callApi()
        }else{
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - API Methods
    
    func callApi(){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/frequencia")!)
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
                                    
                                    let results = jsonResult[LISTA] as? NSArray!
                                    self.frequencyList.removeAll()
                                    
                                    for result in results! {
                                        
                                        let listaData = result as! NSDictionary
                                        let periodosResults = listaData[Periodos] as! NSArray
                                        for periodoResult in periodosResults {
                                            
                                            let noteObj = NotesModel()
                                            let periodosData = periodoResult as! NSDictionary
                                            let periodoKeys = periodosData.allKeys as! [String]
                                            
                                            if periodoKeys.contains("Disciplina") {
                                            
                                                let titulo = periodosData["Titulo"] as! String
                                                let disciplinaResults = periodosData["Disciplina"] as! NSArray
                                                let disciplina = disciplinaResults[0] as! NSDictionary
                                                
                                                let keys = disciplina.allKeys as! [String]
                                                print(keys)
                                                
                                                noteObj.Titulo = titulo
                                                noteObj.Periodo = ""//periodosData["Periodo"] as! String
                                                
                                                for key in keys {
                                                    let discriplinaValue = disciplina[key] as! String
                                                    print(discriplinaValue)
                                                    
                                                    let listObj = NotesList()
                                                    listObj.name = key
                                                    listObj.value = discriplinaValue
                                                    noteObj.DisciplinaList.append(listObj)
                                                }
                                                
                                                self.frequencyList.append(noteObj)
                                            }
                                            
                                        }
                                        
                                        self.tableView.reloadData()
                                    }
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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.frequencyList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = self.frequencyList[section]
        return section.DisciplinaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCellView
        
        // Configure the cell...
        let section = self.frequencyList[indexPath.section]
        let obj = section.DisciplinaList[indexPath.row]
        
        cell.lblName.text = obj.name
        cell.lblValue.text = obj.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier:"SectionCell") as! NoteSectionCell
        
        let sectionObj = self.frequencyList[section]
        headerCell.lblTitle.text = String(format:"Curso : %@",sectionObj.Titulo)
        return headerCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor =  UIColor.clear
        return footerView
    }
    
    private func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
}
