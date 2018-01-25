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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    var loadIndicator: UIView = UIView()
    var window: UIWindow?
    var dict: Dictionary = [String: String]()
    var allResults = [Home]()
    
    var sidebarView: SidebarView!
    var blackScreen: UIView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func initialSettings()
    {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor.blueColor()
        self.title = "Home"
        
        let btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(btnMenuAction))
        btnMenu.tintColor=UIColor.white
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
    
    func openCalenderView()
    {
        let viewController: CalenderVC = self.storyboard?.instantiateViewController(withIdentifier: "calenderVC") as! CalenderVC
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func openNotesView(){
        let viewController: NotesViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func openFrequencyView(){
        let viewController: FrequencyVC = self.storyboard?.instantiateViewController(withIdentifier: "FrequencyVC") as! FrequencyVC
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func openFinancialView(){
        let viewController: FinancialVC = self.storyboard?.instantiateViewController(withIdentifier: "FinancialVC") as! FinancialVC
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func openSecretaryView(){
        let viewController: SecretaryVC = self.storyboard?.instantiateViewController(withIdentifier: "SecretaryVC") as! SecretaryVC
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func openDisclosureView(){
        let viewController: DisclosureVC = self.storyboard?.instantiateViewController(withIdentifier: "DisclosureVC") as! DisclosureVC
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func signOut(){
        print("signout")
        
        self.navigationController?.popViewController(animated: false)
        //    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //    let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //    self.present(newViewController, animated: true, completion: nil)
    }
    
    // MARK: - API Methods
    
    func loadDataFromServer(){
       
        self.loadIndicator = UIHelper.activityIndicator(uiController: self, title: "Carregando")
        
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
                UIHelper.stopsIndicator(view: self.loadIndicator)
            }
            
        }
        
        task.resume()
    }
    
    // MARK: - Side Menu Methods
    
    @objc func btnMenuAction() {
        blackScreen.isHidden=false
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 300, height: self.sidebarView.frame.height)
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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var rowHeight = 240
        
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
        cell.indexRow = indexPath.row
        cell.obj = object
        
        cell.btnLink.addTarget(self, action: #selector(actionOpenWeb(_:)), for: .touchUpInside)
        cell.btnLink.tag = indexPath.row
        
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

extension HomeViewController: SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
        switch row {
        case .profile:
            let vc=EditProfileVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .cronograma:
            openCalenderView()
        case .notas:
            print("Notes")
            openNotesView()
        case .frequencia:
            print("Frequency")
            openFrequencyView()
        case .financeiro:
            print("Financial")
            openFinancialView()
        case .secretaria:
            print("Secretary")
            openSecretaryView()
        case .divulgacao:
            print("Disclosure")
            openDisclosureView()
        case .conveniencia:
            print("convenience")
        case .estagios:
            print("Stages")
        case .ambiente:
            print("Ambient")
        case .suporte:
            print("Support")
        case .sair:
            signOut()
        case .none:
            break
        }
    }
}

