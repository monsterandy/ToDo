//
//  MenuTableViewCell.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/5/8.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuItemImg: UIImageView!
    @IBOutlet weak var menuItemTitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        print("cell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
