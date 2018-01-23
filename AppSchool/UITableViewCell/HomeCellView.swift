//
//  HomeCellView.swift
//  AppSchool
//
//  Created by Safyan on 23/01/18.
//  Copyright © 2018 Safyan. All rights reserved.
//

import UIKit

class HomeCellView: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnLink: UIButton!
    
    @IBOutlet weak var imgViewH: NSLayoutConstraint!
    @IBOutlet weak var btnViewH: NSLayoutConstraint!
    @IBOutlet weak var lblDetailH: NSLayoutConstraint!
    
    var indexRow: Int?
    
    var obj: Home? {
        didSet {
            lblName.text = obj?.TituloNews
            lblDetail.text = obj?.ImagemLegenda
            
            if (obj?.Imagem != "") {
                
                DispatchQueue.main.async {
                    self.imgView.image = UIHelper.decodeImageFromData(strData: (self.obj?.Imagem)!)
                }
                //imgViewH.constant = 120
            }else{
                imgViewH.constant = 0
            }
            
            if (obj?.LinkDestino == "") {
                btnLink.isHidden = true
                btnViewH.constant = 0
            }else{
                btnLink.isHidden = false
                btnLink.setTitle(obj?.LinkTexto,for: .normal)
            }
            
            if (obj?.ImagemLegenda == "") {
                lblDetail.isHidden = true
                lblDetailH.constant = 0
            }else{
                lblDetail.isHidden = false
                //lblDetailH.constant = 22
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
