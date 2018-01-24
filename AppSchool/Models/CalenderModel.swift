//
//  CalenderModel.swift
//
//  Created by Safyan on 23/01/18.
//  Copyright © 2018 Safyan. All rights reserved.
//

import Foundation

class CalenderModel: NSObject {

    var Titulo: String
    var Longitude: String
    var Professor: String
    var Horario: String
    var Latitude: String
    var TextoDescricao: String
    var dateString: String
    
    
    override init() {
        self.Titulo = ""
        self.Longitude = ""
        self.Professor = ""
        self.Horario = ""
        self.Latitude = ""
        self.TextoDescricao = ""
        self.dateString = ""

    }
    
}
