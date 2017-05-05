//
//  TopBar.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/28.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

class TopBar: UINavigationBar, UINavigationBarDelegate {
    
    private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.tintColor = UIColor.yellow
        
        let customView = UIView(frame: CGRect(x: 0, y: 20, width: 320, height: 64))
        titleLabel = UILabel(frame: CGRect(x: 50, y: 18, width: 200, height: 20))
        
        titleLabel.text = "To-Do"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Avenir Next", size: 24)
        
        titleLabel.isUserInteractionEnabled = true
        titleLabel.alpha = 0
        customView.addSubview(titleLabel)
        self.addSubview(customView)
    }
    
    
    func hideTitleLabel() {
        UIView.animate(withDuration: 0.15) {
            self.titleLabel.center.y += 15
            self.titleLabel.alpha = 0
        }
    }
    
    func showTitleLabel() {
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.center.y -= 15
            self.titleLabel.alpha = 1
        }
    }
}
