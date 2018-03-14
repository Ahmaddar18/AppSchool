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

let Titulo = "Titulo"
let Professor = "Professor"
let Horario = "Horario"
let Latitude = "Latitude"
let Longitude = "Longitude"
let Local = "Local"
let TextoDescricao = "TextoDescricao"
let TituloCurso = "TituloCurso"
let CURSO = "CURSO"
let Meses = "Meses"
let CODE = "CODE"



class CalenderVC: BaseViewController {

    @IBOutlet fileprivate weak var koyomi: Koyomi! {
        didSet {
            koyomi.circularViewDiameter = 0.2
            koyomi.calendarDelegate = self
            koyomi.inset = UIEdgeInsets(top: 0, left: 1, bottom: 1, right: 1)
            koyomi.weeks = ("D", "S", "T", "Q", "Q", "S", "S")
            koyomi.style = .standard
            koyomi.dayPosition = .center
            koyomi.cellSpace = 1
            koyomi.selectionMode = .multiple(style: .background)
            koyomi.selectedStyleColor = UIColor(red: 245/255, green: 125/255, blue: 0/255, alpha: 1)
            koyomi
                .setDayFont(size: 12)
                .setWeekFont(size: 16)
        }
    }
    
    @IBOutlet weak var lblMonth: UILabel!
    
    // Custom popup view
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblPopTitle: UILabel!
    @IBOutlet weak var lblPopAula: UILabel!
    @IBOutlet weak var lblPopHorario: UILabel!
    @IBOutlet weak var lblPopDocente: UILabel!
    @IBOutlet weak var lblPopLocal: UILabel!
    @IBOutlet weak var lblPopDescricao: UILabel!
    
    var loadIndicator: UIView = UIView()
    
    var allDays = [CalenderModel]()
    var selectedDays: [Date] = []
    var selectObj = CalenderModel()
    fileprivate let invalidPeriodLength = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initializing()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func initializing () {
        
        //self.title = "Calendário"
        
        let dateString = koyomi.currentDateString()
        let customeMonth = getMonthName(date: UtilityHelper.convertStringDate(dateString, formatFrom: "MMMM yyyy", formatTo: "MMMM"))
        let year = UtilityHelper.convertStringDate(dateString, formatFrom: "MMMM yyyy", formatTo: "yyyy")
        lblMonth.text = String(format:"%@ %@",customeMonth.uppercased(),year)
        
        let month = UtilityHelper.convertStringDate(dateString, formatFrom: "MMMM yyyy", formatTo: "MM")
        
        callCalenderApi(month: month, year: year)
    }
    
    func loadCalenderDays() {
        let today = Date()
        print(today)
        
        for obj in allDays {
            let date = self.convertStrIntoDate(str: obj.DateString)
            print(date)
            selectedDays.append(date)
        }
        
        koyomi.select(dates: selectedDays)
        self.koyomi.reloadData()
    }
    
    func convertStrIntoDate(str: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"// HH:mm:ss
        let date = dateFormatter.date(from: str)!
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date)
        
        let date2 = dateFormatter.date(from: timeStamp)!
        
        return date2
    }
    
    func findDateAndLoadPopup(_ date:String) {
        
        for dayObj in allDays {
            if dayObj.DateString.contains(date) {
                print("date found")
                addPopupView(dayObj)
                break
            }
            
        }
    }
    
    func addPopupView(_ obj: CalenderModel){
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewPopup.frame = frame
        AppDel.window?.addSubview(viewPopup)
        
        setPopupValue(obj)
    }
    
    func setPopupValue(_ obj: CalenderModel) {
        
        lblPopTitle.text = obj.Titulo
        let date = UtilityHelper.convertStringDate(obj.DateString, formatFrom: "yyyy-MM-dd", formatTo: "dd/MM/yyy")
        lblPopAula.text = String(format:"Aula: %@",date)
        lblPopHorario.text = String(format:"Horario: %@",obj.Horario)
        lblPopDocente.text = String(format:"Docente: %@",obj.Professor)
        lblPopLocal.text = String(format:"Local: %@",obj.Local)
        lblPopDescricao.text = String(format:"Descricao: %@",obj.TextoDescricao)
        
        selectObj = obj
    }
    
    // MARK: - API Methods
    
    func callCalenderApi(month: String, year:String){
        
        self.loadIndicator = UIHelper.activityIndicator(view: self.view, title: "Carregando")
        
        let postString = """
        {
        \"setAno\"    :"\(year)",
        \"setMes\"    :"\(month)"
        }
        """
        
        let urlStr = API_Base_Path+"cronograma"
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
                                
                                    let results = jsonResult[CURSO] as? NSArray!
                                    let curcoData = results![0] as! NSDictionary
                                    
                                    let mesesResult = curcoData[Meses] as! NSArray
                                    let messData = mesesResult[0] as! NSDictionary
                                    
                                    let year = String(format:"%d", curcoData["ano"] as! Int)
                                    let title = curcoData[TituloCurso] as! String
                                    let month = messData["mes"] as! String
                                    
                                    var keys = messData.allKeys as! [String]
                                    keys = keys.filter(){$0 != "mes"}
                                    print(keys)
                                    
                                    for key in keys {
                                        let dayResult = messData[key] as! NSArray
                                        let dayData = dayResult[0] as! NSDictionary
                                        
                                        let day = CalenderModel()
                                        
                                        day.Title = title
                                        day.Month = month
                                        day.Year = year
                                        day.Titulo = dayData[Titulo] as! String
                                        day.Longitude = String(format:"%f",dayData[Longitude] as! Double)
                                        day.Professor = dayData[Professor] as! String
                                        day.Horario = dayData[Horario] as! String
                                        day.Local = dayData[Local] as! String
                                        day.Latitude = String(format:"%f",dayData[Latitude] as! Double)
                                        day.TextoDescricao = dayData[TextoDescricao] as! String
                                        day.DateString = String(format:"%@-%@-%@",year,month,key)// 10:30:55
                                        
                                        self.allDays.append(day)
                                    }
                                    
                                    print(self.allDays)

                                }
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
    
    // MARK: - Action Methods
    
    @IBAction func actionClosePopup(_ sender: UIButton) {
        viewPopup.removeFromSuperview()
    }
    
    @IBAction func actionOpenMap(_ sender: UIButton) {
        
        //let url = "http://maps.apple.com/?ll=\(31.511075),\(74.340176)"
        let url = "http://maps.apple.com/?ll=\(String(describing: selectObj.Latitude)),\(String(describing: selectObj.Longitude))"

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string:url)!)
        } else {
            // Fallback on earlier versions
        }
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
    
    func getMonthName(date: String) -> String {
        
        if (date.contains("January")) {
            return "Janeiro"
        } else if (date.contains("February")) {
            return "Fevereiro"
        } else if (date.contains("March")) {
            return "Março"
        } else if (date.contains("April")) {
            return "Abril"
        } else if (date.contains("May")) {
            return "Maio"
        } else if (date.contains("June")) {
            return "Junho"
        } else if (date.contains("July")) {
            return "Julho"
        } else if (date.contains("August")) {
            return "Agosto"
        } else if (date.contains("September")) {
            return "Setembro"
        } else if (date.contains("October")) {
            return "Outubro"
        } else if (date.contains("November")) {
            return "Novembro"
        } else if (date.contains("December")) {
            return "Dezembro"
        } else {
            return date;
        }
    }
}

// MARK: - KoyomiDelegate -
    
extension CalenderVC: KoyomiDelegate {
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        print("You Selected: ",date!)
        
        let datee = UtilityHelper.convertDateToString(date!, withFormat: "yyyy-MM-dd'T'HH:mm:ss")
        let date = UtilityHelper.convertStringDate(datee, formatFrom: "yyyy-MM-dd'T'HH:mm:ss", formatTo: "yyyy-MM-dd")
        print(date)
        
        findDateAndLoadPopup(date)
    }
    
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
        
        let customeMonth = getMonthName(date: UtilityHelper.convertStringDate(dateString, formatFrom: "MMMM yyyy", formatTo: "MMMM"))
        let month = UtilityHelper.convertStringDate(dateString, formatFrom: "MMMM yyyy", formatTo: "MM")
        let year = UtilityHelper.convertStringDate(dateString, formatFrom: "MMMM yyyy", formatTo: "yyyy")
        callCalenderApi(month: month, year: year)
        
        lblMonth.text = String(format:"%@ %@",customeMonth.uppercased(), year)
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

