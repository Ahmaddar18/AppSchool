//
//  WebCellView.swift
//  AppSchool
//
//  Created by Fasih on 1/30/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class WebCellView: UITableViewCell {
    
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var btnWeb: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dropShadow()
        
        //underline()
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
        guard let text = btnWeb.titleLabel?.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        btnWeb.setAttributedTitle(attributedString, for: .normal)
    }
}
