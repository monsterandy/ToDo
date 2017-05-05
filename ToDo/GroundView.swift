//
//  GroundView.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/30.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

private let kScreenHeight: CGFloat = 152.0

class GroundView: UIView {
    
    private var progress: CGFloat = 0.0
    private var bgImg: UIImage!
    internal var topMaskView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        bgImg = UIImage(named: "bg")
        let imgView = UIImageView(image: bgImg)
        imgView.frame = self.frame
        self.addSubview(imgView)
        topMaskView = UIView(frame: self.frame)
        topMaskView.backgroundColor = UIColor(red: 198/255, green: 60/255, blue: 34/255, alpha: 0)
        self.addSubview(topMaskView)
        
        self.backgroundColor = UIColor(red: 60/255, green: 160/255, blue: 183/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAlpha(_ contentOffsetY: CGFloat) {
        progress = min(contentOffsetY / kScreenHeight, 1)
        topMaskView.backgroundColor = UIColor(red: 198/255, green: 60/255, blue: 34/255, alpha: progress)
    }

}
