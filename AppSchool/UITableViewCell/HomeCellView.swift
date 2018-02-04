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
    @IBOutlet weak var viewInner: UIView!
    
    @IBOutlet weak var imgViewH: NSLayoutConstraint!
    @IBOutlet weak var btnViewH: NSLayoutConstraint!
    @IBOutlet weak var lblDetailH: NSLayoutConstraint!
    @IBOutlet weak var viewInnerH: NSLayoutConstraint!
    
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
        
        dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dropShadow() {
        
        viewInner.layer.shadowColor = UIColor.lightGray.cgColor
        viewInner.layer.shadowOpacity = 1
        viewInner.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        viewInner.layer.shadowRadius = 3
    }
    
    func underline() {
        guard let text = btnLink.titleLabel?.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        btnLink.setAttributedTitle(attributedString, for: .normal)
    }

}
