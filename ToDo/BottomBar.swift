//
//  BottomBar.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/30.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

protocol BottomBarDelegate: class {
    func bottomBarDidMovedUp(bottomBar: BottomBar, deltaY: CGFloat)
    func bottomBarDidMovedDown(bottomBar: BottomBar)
}

class BottomBar: UIView {
    
    private var addImageView: UIImageView!
    private var addTextField: UITextField!
    private var addButton: UIButton!
    
    weak var delegate: BottomBarDelegate?
    
    override func awakeFromNib() {
        print("awakeFromNib()")
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.black
        
        let testLabel = UILabel(frame: self.frame)
        testLabel.text = "test"
        addSubview(testLabel)
        
        
        let testView = UIView(frame: self.frame)
        testView.backgroundColor = UIColor.black
        self.addSubview(testView)
        print(self.frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bgImgView = UIImageView(image: UIImage(named: "bottomBarImg"))
        bgImgView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(bgImgView)
        addImageView = UIImageView(frame: CGRect(x: 18, y: 17, width: 25, height: 25))
        addImageView.image = UIImage(named: "addLabel")
        self.addSubview(addImageView)
        addTextField = UITextField(frame: CGRect(x: 60, y: 15, width: self.frame.width * 0.7, height: 30))
        addTextField.borderStyle = .none
        addTextField.text = "Add a new todo"
        addTextField.clearButtonMode = .whileEditing
        addTextField.textColor = UIColor(red: 222/255, green: 106/255, blue: 106/255, alpha: 1)
        addTextField.font = UIFont(name: "System", size: 17.0)
        self.addSubview(addTextField)
        addButton = UIButton(frame: CGRect(x: self.frame.width - 40, y: 17, width: 25, height: 25))
        addButton.setImage(UIImage(named: "addButton"), for: UIControlState.normal)
        addButton.isEnabled = false
        addButton.alpha = 0
        
        self.addSubview(addButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHiden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func cancelEdit() {
        self.addTextField.resignFirstResponder()
    }
    
    func addEditMaskView(_ origin: CGPoint) {
        let maskView = UIView(frame: CGRect(x: 0, y: -(origin.y-84), width: self.frame.width, height: origin.y-84))
        maskView.backgroundColor = UIColor.blue
        maskView.alpha = 0.5
        maskView.isUserInteractionEnabled = true
        self.addSubview(maskView)
    }
    
    
    
    func keyboardWillShow(note: NSNotification) {
        self.addTextField.text = nil
        self.addTextField.placeholder = "Type your to-do"
        self.addTextField.font = UIFont(name: "System", size: 16.0)
        self.addButton.alpha = 1
        self.addTextField.textColor = UIColor.black
        self.addImageView.image = UIImage(named: "addLabelEdited")
        
        let userInfo = note.userInfo!
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: { 
                self.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
            }, completion: nil)
            delegate?.bottomBarDidMovedUp(bottomBar: self, deltaY: deltaY)
        } else {
            self.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
        }
    }
    
    func keyBoardWillHiden(note: NSNotification) {
        self.addTextField.text = "Add a new todo"
        self.addTextField.textColor = UIColor(red: 222/255, green: 106/255, blue: 106/255, alpha: 1)
        self.addTextField.font = UIFont(name: "System", size: 17.0)
        self.addButton.alpha = 0
        self.addImageView.image = UIImage(named: "addLabel")
        
        let userInfo = note.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
            delegate?.bottomBarDidMovedDown(bottomBar: self)
        } else {
            self.transform = CGAffineTransform.identity
        }

    }
    
    
    
}
