//
//  TopView.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/23.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

private let kScreenHeight: CGFloat = 152.0

class TopView: UIView, UIScrollViewDelegate {
    
    private unowned var scrollView: UIScrollView
    private var progress: CGFloat = 0.0
    var isDown: Bool = false
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        //        backgroundColor = UIColor.cyan
        //        lockTopView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBackgroundColor() {
        backgroundColor = UIColor(red: 60/255, green: 160/255, blue: 183/255, alpha: 0.3 * progress + 0.7)
    }
    
    func lockTopView(withVelocity velocity: Double) {
        isDown = true
//        self.scrollView.contentInset.top += kScreenHeight
        UIView.animate(withDuration: 0.4*1/(-velocity+1), delay: 0, options: .curveEaseOut, animations: {

//            self.scrollView.contentOffset.y -= kScreenHeight + 100
            self.scrollView.contentInset.top += kScreenHeight

        }, completion: nil)
    }
    
    func unlockTopView(withVelocity velocity: Double) {
        isDown = false
//        self.scrollView.contentInset.top -= kScreenHeight
        UIView.animate(withDuration: 0.4*1/(velocity+1), delay: 0, options: .curveEaseOut, animations: {
//            self.scrollView.contentOffset.y += kScreenHeight + 100

            self.scrollView.contentInset.top -= kScreenHeight

        }, completion: nil)
    }
    
    func showBigTitle() {
        if progress > 0.5 {
            print(1111)
            let bigTitleLabel: UILabel = UILabel(frame: CGRect(x: 60, y: 60, width: 100, height: 50))
            bigTitleLabel.text = "To-Do"
            bigTitleLabel.textColor = UIColor.black
            addSubview(bigTitleLabel)
            
        }
    
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if fabs(velocity.y) > 0.4  {
            if isDown && velocity.y>0{
                unlockTopView(withVelocity: Double(velocity.y))
            } else if !isDown && velocity.y<0 {
                lockTopView(withVelocity: Double(velocity.y))
            }
        } else {
            if progress > 0.1 && !isDown {
                lockTopView(withVelocity: Double(velocity.y))
                targetContentOffset.pointee.y = -scrollView.contentInset.top
            }
            if progress <= 0.9 && isDown {
                unlockTopView(withVelocity: Double(velocity.y))
            }
        }
        print(velocity)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topViewVisibleHeight = max(0,-scrollView.contentOffset.y - 84)
        progress = min(1, topViewVisibleHeight / kScreenHeight)
        updateBackgroundColor()
//        showBigTitle()
    }
    
}
