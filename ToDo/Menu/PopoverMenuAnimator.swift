//
//  PopoverMenuAnimator.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/5/10.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

class PopoverMenuAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    //定义一个变量,记录当前是展开状态还是消失状态
    var isPresent: Bool = false
    
    //保存弹出窗口的大小
    var presentFrame = CGRect.zero
    
    //实现代理方法,告诉系统谁来负责转场动画
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let pc = PopoverActionPresentController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    //只要实现了以下方法,系统默认的动画效果就没有了,需要自己实现
    //谁来负责modal的展现动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning协议方法
    /**
     动画时长
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    //如果动画,无论是展开还是消失,都会这个方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            
            //来到这里说明要执行展开操作
            //拿到展现视图
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            
            //把高度压缩为0
            toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0)
            
            //把视图添加容器上
            transitionContext.containerView.addSubview(toView!)
            
            //设置锚点(由默认的中点移到上面)
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            //执行动画
            
            
            
            
        } else {
        
        }
    }
    
}
