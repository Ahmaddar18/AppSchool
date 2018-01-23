//
//  CalenderVC.swift
//  AppSchool
//
//  Created by Ahmad on 1/16/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class CalenderVC: UIViewController {

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
