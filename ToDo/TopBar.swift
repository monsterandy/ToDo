//
//  TopBar.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/28.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

class TopBar: UINavigationBar, UINavigationBarDelegate, UITextFieldDelegate {
    
    private var customView: UIView!
    private var titleLabel: UILabel!
    private var titleText: String!
    private var titleTextField: UITextField!
    private var menuButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.tintColor = UIColor.yellow
        
        titleText = "To-Do"
        customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        titleLabel = UILabel(frame: CGRect(x: 50, y: 28, width: UIScreen.main.bounds.width - 100, height: 40))
        titleLabel.text = titleText
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Avenir Next", size: 24)
        titleLabel.isUserInteractionEnabled = true
        titleLabel.alpha = 0
        
        let titleLabelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelTapped(sender:)))
        titleLabel.addGestureRecognizer(titleLabelTapRecognizer)
        
        titleTextField = UITextField(frame: CGRect(x: 50, y: 14, width: UIScreen.main.bounds.width - 100, height: 40))
        titleTextField.borderStyle = .none
        let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next", size: 24.0)!]
        titleTextField.attributedText = NSAttributedString(string: titleText, attributes: attributes)
        titleTextField.tintColor = UIColor.blue
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.returnKeyType = .done
        
        titleTextField.layer.cornerRadius = 4.0
        titleTextField.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
        titleTextField.alpha = 0
        titleTextField.delegate = self
        
        menuButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 45, y: 14, width: 40, height: 40))
        menuButton.tintColor = UIColor.white
        menuButton.setTitle("M", for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(self.menuButtonTapped), for: UIControlEvents.touchUpInside)
        customView.addSubview(menuButton)
        customView.addSubview(titleLabel)
        customView.addSubview(titleTextField)
        self.addSubview(customView)
    }
    
    func titleLabelTapped(sender: UITapGestureRecognizer) {
        let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next", size: 24.0)!]
        self.titleTextField.attributedText = NSAttributedString(string: titleText, attributes: attributes)
        self.titleLabel.alpha = 0
        self.titleTextField.alpha = 1
        self.titleTextField.becomeFirstResponder()
    }
    
    func menuButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "menuButtonTapped"), object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.finishEdit()
        return true
    }
    
    func finishEdit() {
        self.titleText = self.titleTextField.text
        self.titleLabel.text = self.titleText
        self.titleTextField.resignFirstResponder()
        self.titleTextField.alpha = 0
        self.titleLabel.alpha = 1
    }
    
    func getTitleText() -> String {
        return titleText
    }
    
    func setTitleText(_ text: String) {
        self.titleText = text
        self.titleLabel.text = self.titleText
    }
    
    func getTitleTextField() -> UITextField {
        return self.titleTextField
    }
    
    func hideTitleLabel() {
        UIView.animate(withDuration: 0.15) {
            self.titleLabel.center.y += 15
            self.titleLabel.alpha = 0
            self.titleLabel.isUserInteractionEnabled = false
        }
    }
    
    func showTitleLabel() {
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.center.y -= 15
            self.titleLabel.alpha = 1
            self.titleLabel.isUserInteractionEnabled = true
        }
    }
    
}
