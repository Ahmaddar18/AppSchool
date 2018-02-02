//
//  FinancialCell.swift
//  AppSchool
//
//  Created by Fasih on 2/1/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class FinancialCell: UITableViewCell {
    
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    @IBOutlet weak var btnValue: UIButton!
    @IBOutlet weak var btnUpload: UIButton!

    var obj: Financial? {
        didSet {
            lblDate.text = obj?.Vencimento
            if obj?.StatusPagto == "Em Aberto" {
                lblStatus.text = "Aberto"
                btnUpload.isHidden = false
            }else{
                lblStatus.text = "Pago"
                btnValue.isHidden = false
            }
            
            lblValue.text = obj?.Valor
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dropShadow(view: viewOne)
        dropShadow(view: viewTwo)
        dropShadow(view: viewThree)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dropShadow(view: UIView) {
        
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3
    }

}
