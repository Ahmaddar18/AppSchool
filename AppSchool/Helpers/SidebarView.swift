//
//  Sidebar.swift
//  mySidebar2
//
//  Created by Muskan on 10/12/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import Foundation
import UIKit

protocol SidebarViewDelegate: class {
    func sidebarDidSelectRow(row: Row)
}

enum Row: String {
    case profile
    case cronograma
    case notas
    case frequencia
    case financeiro
    case secretaria
    case divulgacao
    case conveniencia
    case estagios
    case ambiente
    case suporte
    case sugestoes
    case sair
    case none
    
    init(row: Int) {
        switch row {
        case 0: self = .profile
        case 1: self = .cronograma
        case 2: self = .notas
        case 3: self = .frequencia
        case 4: self = .financeiro
        case 5: self = .secretaria
        case 6: self = .divulgacao
        case 7: self = .conveniencia
        case 8: self = .estagios
        case 9: self = .ambiente
        case 10: self = .suporte
        case 11: self = .sugestoes
        case 12: self = .sair
        default: self = .none
        }
    }
}

class SidebarView: UIView, UITableViewDelegate, UITableViewDataSource {

    var titleArr = [String]()
    var name: String?
    var email: String?
    
    weak var delegate: SidebarViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor=UIColor(red: 54/255, green: 55/255, blue: 56/255, alpha: 1.0)
        //self.clipsToBounds=true
        
        self.layer.contents = #imageLiteral(resourceName: "bgnormal").cgImage
        
        titleArr = ["PROFILE","CRONOGRAMA", "NOTAS", "FREQUÊNCIA", "FINANCEIRO", "SECRETARIA ON-LINE", "DIVULGAÇÃO E INSCRIÇÕES","CONVENIÊNCIA","ESTÁGIOS","AMBIENTE EAD","SUPORTE","SUGESTÕES","SAIR"]
        
        setupViews()
        
        myTableView.delegate=self
        myTableView.dataSource=self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.tableFooterView=UIView()
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        myTableView.allowsSelection = true
        myTableView.bounces=false
        myTableView.showsVerticalScrollIndicator=false
        myTableView.backgroundColor = UIColor.clear
        
        let dictUser = USER_DEFAULTS.value(forKey: LOGGEDIN_USER_INFO) as? NSDictionary
        name = dictUser![NAME] as? String
        email = dictUser![EMAIL] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row == 0 {
//            cell.backgroundColor=UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
//            let cellImg: UIImageView!
//            cellImg = UIImageView(frame: CGRect(x: 15, y: 10, width: 80, height: 80))
//            cellImg.layer.cornerRadius = 40
//            cellImg.layer.masksToBounds=true
//            cellImg.contentMode = .scaleAspectFill
//            cellImg.layer.masksToBounds=true
//            cellImg.image=#imageLiteral(resourceName: "user")
//            cell.addSubview(cellImg)
            
            let cellLbl = UILabel(frame: CGRect(x: 30, y: cell.frame.height/2-15, width: cell.frame.width, height: 30))
            cell.addSubview(cellLbl)
            cellLbl.text = name //"John Doe"
            cellLbl.font=UIFont.boldSystemFont(ofSize: 18)
            cellLbl.textColor=UIColor.white
            
            let cellDetailLbl = UILabel(frame: CGRect(x: 30, y:25+( cell.frame.height/2-15), width: cell.frame.width, height: 30))
            cell.addSubview(cellDetailLbl)
            cellDetailLbl.text = email//"teste@empresa.com"
            cellDetailLbl.font=UIFont.systemFont(ofSize: 17)
            cellDetailLbl.textColor=UIColor.white
            
            let lblLine = UILabel()
            lblLine.frame = CGRect(x: 15, y:( cell.frame.height-5), width: cell.frame.width-30, height: 2)
            lblLine.backgroundColor = UIColor.orangeColor()
            cell.addSubview(lblLine)
            
        } else if indexPath.row == titleArr.count - 2 {
            
            let lblLine = UILabel()
            lblLine.frame = CGRect(x: 7, y:( cell.frame.height), width: cell.frame.width-30, height: 2)
            lblLine.backgroundColor = UIColor.orangeColor()
            cell.addSubview(lblLine)
            
            let x = (cell.frame.size.width/16) - 30
            cell.bounds.origin.x = x
            cell.textLabel?.text=titleArr[indexPath.row]
            cell.textLabel?.textColor=UIColor.white
            cell.textLabel?.textAlignment = NSTextAlignment.left
            cell.textLabel?.font=UIFont.systemFont(ofSize: 14)
            
        } else if indexPath.row == titleArr.count - 1 {
            
            let x = (cell.frame.size.width/16) - 10
            cell.bounds.origin.x = x
            cell.textLabel?.text=titleArr[indexPath.row]
            cell.textLabel?.textColor=UIColor.white
            cell.textLabel?.textAlignment = NSTextAlignment.right
            cell.textLabel?.font=UIFont.systemFont(ofSize: 14)
            
        } else {
            let x = (cell.frame.size.width/16) - 30
            cell.bounds.origin.x = x
            cell.textLabel?.text=titleArr[indexPath.row]
            cell.textLabel?.textColor=UIColor.white
            cell.textLabel?.font=UIFont.systemFont(ofSize: 14)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0)
        {
        self.delegate?.sidebarDidSelectRow(row: Row(row: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else if indexPath.row == titleArr.count - 2 {
            return 50
        } else {
            return 45
        }
    }
    
    func setupViews() {
        self.addSubview(myTableView)
        myTableView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let myTableView: UITableView = {
        let table=UITableView()
        table.translatesAutoresizingMaskIntoConstraints=false
        return table
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


