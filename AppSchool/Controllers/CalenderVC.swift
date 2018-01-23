//
//  CalenderVC.swift
//  AppSchool
//
//  Created by Ahmad on 1/16/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit
import Koyomi

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
            koyomi.selectedStyleColor = UIColor(red: 203/255, green: 119/255, blue: 223/255, alpha: 1)
            koyomi
                .setDayFont(size: 14)
                .setWeekFont(size: 10)
        }
    }
    
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
        
    }
    
}

// MARK: - KoyomiDelegate -

extension CalenderVC: KoyomiDelegate {
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        print("You Selected: ",date)
    }
    
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
        //currentDateLabel.text = dateString
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

