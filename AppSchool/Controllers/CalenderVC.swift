//
//  CalenderVC.swift
//  AppSchool
//
//  Created by Ahmad on 1/16/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit
import Koyomi

let MONTH = "01"
let YEAR = "2018"

let d1 = "01"
let d2 = "02"
let d5 = "05"

struct calenderData : Decodable {
    let RESPONSE : String?
    let MENSAGEMERRO : String?
    let CURSO : [calNestedData]
}
struct calNestedData : Decodable {
    let TituloCurso : String?
    let ano : String?
    var Meses: [String: String]
}
struct mesesData : Decodable {
    let mes : String?
}
struct dayData : Decodable {
    let Titulo : String?
    let Longitude : String?
    let twProfessoro : String?
    let Horario : String?
    let Latitude : String?
    let TextoDescricao : String?
}


class CalenderVC: UIViewController {

    @IBOutlet fileprivate weak var koyomi: Koyomi! {
        didSet {
            koyomi.circularViewDiameter = 0.2
            koyomi.calendarDelegate = self
            koyomi.inset = UIEdgeInsets(top: 0, left: 1, bottom: 1, right: 1)
            koyomi.weeks = ("S", "M", "T", "W", "T", "F", "S")
            koyomi.style = .standard
            koyomi.dayPosition = .center
            koyomi.cellSpace = 1
            koyomi.selectionMode = .multiple(style: .background)
            koyomi.selectedStyleColor = UIColor(red: 230/255, green: 26/255, blue: 24/255, alpha: 1)
            koyomi
                .setDayFont(size: 12)
                .setWeekFont(size: 16)
        }
    }
    
    @IBOutlet weak var lblMonth: UILabel!
    
    var loadIndicator: UIView = UIView()
    var allDays = [CalenderModel]()
    
    fileprivate let invalidPeriodLength = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Calender"
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
        self.title = "Calender"
        
        lblMonth.text = koyomi.currentDateString()
        
        callCalenderApi(month: MONTH, year: YEAR)
    }
    
    func loadCalenderDays() {
        let today = Date()
        print(today)
        
        var selectedDays: [Date] = []
        
        for obj in allDays {
            let date = self.convertStrIntoDate(str: obj.dateString)
            print(date)
            selectedDays.append(date)
        }
        
        //self.updateCalender(selectedDays: selectedDays)
        koyomi.select(dates: selectedDays)
        self.view.layoutIfNeeded()
        //self.setNeedsFocusUpdate()
    }
    
    func convertStrIntoDate(str: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: str)!
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date)
        
        let date2 = dateFormatter.date(from: timeStamp)!
        
        return date2
    }
    
    // MARK: - API Methods
    
    func callCalenderApi(month: String, year:String){
        
        self.loadIndicator = UIHelper.activityIndicator(uiController: self, title: "Carregando")
        
        let postString = """
        {
        \"setAno\"    :"\(year)",
        \"setMes\"    :"\(month)"
        }
        """
        
        var request = URLRequest(url: URL(string: "http://52.10.244.229:8888/rest/wsapimob/cronograma")!)
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
                                let results = jsonResult["CURSO"] as? NSArray!
                                let curcoData = results![0] as! NSDictionary
                                
                                let mesesResult = curcoData["Meses"] as! NSArray
                                let messData = mesesResult[0] as! NSDictionary
                                
                                let year = curcoData["ano"] as! String
                                let title = curcoData["TituloCurso"] as! String
                                let month = messData["mes"] as! String
                                
                                var keys = messData.allKeys as! [String]
                                keys = keys.filter(){$0 != "mes"}
                                print(keys)
                                
                                for key in keys {
                                    let dayResult = messData[key] as! NSArray
                                    let dayData = dayResult[0] as! NSDictionary
                                    
                                    let day = CalenderModel()
                                    
                                    day.Titulo = dayData["Titulo"] as! String
                                    day.Longitude = dayData["Longitude"] as! String
                                    day.Professor = dayData["Professor"] as! String
                                    day.Horario = dayData["Horario"] as! String
                                    day.Latitude = dayData["Latitude"] as! String
                                    day.TextoDescricao = dayData["TextoDescricao"] as! String
                                    day.dateString = String(format:"%@-%@-%@ 10:30:55",year,month,key)
                                    
                                    self.allDays.append(day)
                                }
                                
                                print(self.allDays)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.loadCalenderDays()
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
    
}

extension CalenderVC {
    @IBAction func tappedControl(_ sender: UIButton) {
        let btnsend: UIButton = sender
        
        let month: MonthType = {
            switch btnsend.tag {
            case -1:  return .previous
            case 0:  return .current
            default: return .next
            }
        }()
        koyomi.display(in: month)
    }
    
    func updateCalender(selectedDays: [Date]) {
        koyomi.select(dates: selectedDays)
    }
}

// MARK: - KoyomiDelegate -
    
extension CalenderVC: KoyomiDelegate {
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        print("You Selected: ",date!)
    }
    
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
        lblMonth.text = dateString
    }
    
    @objc(koyomi:shouldSelectDates:to:withPeriodLength:)
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        if length > invalidPeriodLength {
            print("More than \(invalidPeriodLength) days are invalid period.")
            return false
        }
        return true
    }
}

