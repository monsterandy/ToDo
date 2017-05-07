//
//  BottomBar.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/30.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit


class BottomBar: UIView, UITextFieldDelegate {
    
    private var addImageView: UIImageView!
    private var addTextField: UITextField!
    private var addButton: UIButton!
    
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
        addTextField.delegate = self
        self.addSubview(addTextField)
        addButton = UIButton(frame: CGRect(x: self.frame.width - 40, y: 17, width: 25, height: 25))
        addButton.setImage(UIImage(named: "addButton"), for: UIControlState.normal)
        addButton.isEnabled = false
        addButton.alpha = 0
        self.addSubview(addButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelEdit() {
        self.addTextField.resignFirstResponder()
        self.addTextField.text = "Add a new todo"
        self.addTextField.textColor = UIColor(red: 222/255, green: 106/255, blue: 106/255, alpha: 1)
        self.addTextField.font = UIFont(name: "System", size: 17.0)
        self.addButton.alpha = 0
        self.addImageView.image = UIImage(named: "addLabel")
    }
    
    func getAddTextField() -> UITextField {
        return self.addTextField
    }
    
    func setAddTextFieldEnable(_ isEnable: Bool) {
        self.addTextField.isUserInteractionEnabled = isEnable
    }
    
    func prepareForEdit() {
        self.addTextField.text = nil
        self.addTextField.placeholder = "Type your to-do"
        self.addTextField.font = UIFont(name: "System", size: 16.0)
        self.addButton.alpha = 1
        self.addTextField.textColor = UIColor.black
        self.addImageView.image = UIImage(named: "addLabelEdited")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

}
