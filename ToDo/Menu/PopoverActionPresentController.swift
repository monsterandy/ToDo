//
//  PopoverActionPresentController.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/5/10.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

var popoverMenuHeight: CGFloat = 350

class PopoverActionPresentController: UIPresentationController {
    
    //定义一个属性保存弹出菜单的大小
    var presentFrame = CGRect.zero
    
    /**
     重写初始化方法,用于创建负责转场的动画
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起的控制器
     
     - returns:
     */
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /**
     重写containerViewWillLayoutSubviews,在即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews() {
        //修改弹出视图的大小
        //presentedView: 被展现的视图
        //containerView: 容器视图
        if presentFrame == CGRect.zero {
            presentedView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - popoverMenuHeight, width: UIScreen.main.bounds.width, height: popoverMenuHeight)
        } else {
            presentedView?.frame = self.presentFrame
        }
        containerView?.insertSubview(converView, at: 0)
        
    }
    
    //MARK: -懒加载蒙版
    fileprivate lazy var converView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        view.frame = UIScreen.main.bounds
        
        //为蒙版view添加一个监听,点击蒙版的时候,转场消失
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopoverActionPresentController.close))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    func close() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
