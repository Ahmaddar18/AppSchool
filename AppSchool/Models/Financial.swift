//
//  Financial.swift
//  AppSchool
//
//  Created by Fasih on 2/1/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import Foundation

class Financial: NSObject {
    
    var CodigoBarras: String
    var IdTitulo: String
    var StatusPagto: String
    var Titulo: String
    var Valor: String
    var Vencimento: String
    
    override init() {
        self.CodigoBarras = ""
        self.IdTitulo = ""
        self.StatusPagto = ""
        self.Titulo = ""
        self.Valor = ""
        self.Vencimento = ""
        
    }
    
}
