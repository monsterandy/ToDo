//
//  ToDoViewController.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/29.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

var activeField: UITextField?

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var groundView: GroundView!
    var topBar: TopBar!
    var bottomBar: BottomBar!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewTitleLabel: UILabel!
    private var headerViewTitleTextField: UITextField!
    @IBOutlet weak var footerView: UIView!
    private var isBgChanged = false
    private var isTitleHided = false
    private var isEditViewMovedUp = false
    private var todoCount:CGFloat = 8
    private var moveScale:CGFloat = 0
    private var baseFooterViewHeight: CGFloat = 583.0
    private var footerViewHeight: CGFloat = 583.0
    private var notScrollMaxCells: CGFloat = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topBar = (self.navigationController?.navigationBar)! as! TopBar
        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "todoCell")
        self.tableView.delegate = self
        self.tableView.rowHeight = 48.0
        self.tableView.tableFooterView = footerView
        self.tableView.backgroundView?.backgroundColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.showsVerticalScrollIndicator = false
        let frame = footerView.frame
        self.setfooterViewHeight()
        footerView.frame = CGRect(x: frame.origin.x
            , y: frame.origin.y, width: frame.size.width, height: footerViewHeight)
        footerView.backgroundColor = UIColor.groupTableViewBackground
        
        self.headerView.backgroundColor = UIColor.clear
        self.headerViewTitleLabel.text = topBar.getTitleText()
        let titleLabelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelTapped(sender:)))
        self.headerViewTitleLabel.addGestureRecognizer(titleLabelTapRecognizer)
        self.headerViewTitleLabel.isUserInteractionEnabled = true
        self.headerViewTitleTextField = UITextField(frame: CGRect(x: 21, y: 90, width: self.view.frame.width-21*2, height: 50))
        self.headerViewTitleTextField.borderStyle = .none
        self.headerViewTitleTextField.tintColor = UIColor.blue
        self.headerViewTitleTextField.clearButtonMode = .whileEditing
        self.headerViewTitleTextField.layer.cornerRadius = 4.0
        self.headerViewTitleTextField.backgroundColor = UIColor(white: 0.6, alpha: 0.7)
        self.headerViewTitleTextField.alpha = 0
        self.headerViewTitleTextField.delegate = self
        self.headerViewTitleTextField.returnKeyType = .done
        let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next", size: 38.0)!]
        self.headerViewTitleTextField.attributedText = NSAttributedString(string: self.headerViewTitleLabel.text!, attributes: attributes)
        self.headerView.addSubview(headerViewTitleTextField)
        
        groundView = GroundView(frame: view.frame)
        self.view.insertSubview(groundView, belowSubview: tableView)
        bottomBar = BottomBar(frame: CGRect(x: 0, y: self.view.frame.height-57, width: self.view.frame.width, height: 57))
        self.view.addSubview(bottomBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNavigationBar), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHiden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showMenuViewController), name: Notification.Name(rawValue: "menuButtonTapped"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationBar()
    }
    
    func setNavigationBar() {
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 64)
    }
    
    func showMenuViewController() {
        let menuVC = MenuViewController()
        self.present(menuVC, animated: true, completion: nil)
    }
    
    // MARK - Title Label
    func hideHeaderTitle() {
        UIView.animate(withDuration: 0.15) {
            self.headerViewTitleLabel.alpha = 0
        }
    }
    
    func showHeaderTitle() {
        self.headerViewTitleLabel.text = topBar.getTitleText()
        UIView.animate(withDuration: 0.2) {
            self.headerViewTitleLabel.alpha = 1
        }
    }
    
    func titleLabelTapped(sender: UITapGestureRecognizer) {
        self.headerViewTitleLabel.alpha = 0
        self.headerViewTitleTextField.alpha = 1
        self.headerViewTitleTextField.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.headerViewTitleTextField.resignFirstResponder()
        self.topBar.setTitleText(self.headerViewTitleTextField.text!)
        self.headerViewTitleLabel.text = self.topBar.getTitleText()
        self.headerViewTitleTextField.alpha = 0
        self.headerViewTitleLabel.alpha = 1
        return true
    }
    
    func setfooterViewHeight() {
        switch self.view.frame.height {
        case 667.0:
            self.baseFooterViewHeight = 583.0
            self.notScrollMaxCells = 9
        case 736.0:
            self.baseFooterViewHeight = 652.0
            self.notScrollMaxCells = 12
        default:
            self.baseFooterViewHeight = 583.0
            self.notScrollMaxCells = 9
        }
        
        if todoCount > notScrollMaxCells {
            self.footerViewHeight = self.baseFooterViewHeight - notScrollMaxCells * self.tableView.rowHeight
        } else {
            self.footerViewHeight = self.baseFooterViewHeight - todoCount * self.tableView.rowHeight
        }
    }
    
    // MARK - Notification Center
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyboardBounds.size.height
        if let activeField = activeField {
            if activeField == self.headerViewTitleTextField {
                // headerView
                self.tableView.isScrollEnabled = false
            } else if activeField == self.topBar.getTitleTextField() {
                // topBar
                self.tableView.isUserInteractionEnabled = false
            } else if activeField == self.bottomBar.getAddTextField() {
                self.bottomBar.prepareForEdit()
                if duration > 0 {
                    let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
                    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                        self.bottomBar.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
                    }, completion: nil)
                    self.bottomBarDidMovedUp()
                } else {
                    self.bottomBar.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
                }
            }
        }
    }
    
    func keyBoardWillHiden(note: NSNotification) {
        let userInfo = note.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if let activeField = activeField {
            if activeField == self.headerViewTitleTextField {
                // headerView
                self.tableView.isScrollEnabled = true
            } else if activeField == self.topBar.getTitleTextField() {
                // topBar
                self.tableView.isUserInteractionEnabled = true
            } else if activeField == self.bottomBar.getAddTextField() {
                if duration > 0 {
                    let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
                    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                        self.bottomBar.transform = CGAffineTransform.identity
                    }, completion: nil)
                    self.bottomBarDidMovedDown()
                } else {
                    self.bottomBar.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    // MARK - Bottom Bar Delegate
    func bottomBarDidMovedUp() {
        let contentSize: CGFloat
        if isTitleHided {
            contentSize = todoCount * self.tableView.rowHeight + 84
        } else {
            contentSize = todoCount * self.tableView.rowHeight + 152 + 84
        }
        if !isEditViewMovedUp {
            self.moveScale = contentSize - (self.view.bounds.height - 289.5 - 101.5)
        }
        if !isTitleHided && moveScale < 152 {
            self.moveScale = 152.0
        }
        if !isEditViewMovedUp && moveScale > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentOffset.y += self.moveScale
            })
            self.tableView.isUserInteractionEnabled = false
        }
        self.isEditViewMovedUp = true
    }
    
    func bottomBarDidMovedDown() {
        if isEditViewMovedUp && moveScale > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentOffset.y -= self.moveScale
            })
            self.tableView.isUserInteractionEnabled = true
        }
        self.isEditViewMovedUp = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if activeField == self.topBar.getTitleTextField() {
            self.topBar.finishEdit()
        }
        if activeField == self.bottomBar.getAddTextField() {
            self.bottomBar.cancelEdit()
        }
        if activeField == self.headerViewTitleTextField {
            self.headerViewTitleTextField.resignFirstResponder()
            self.topBar.setTitleText(self.headerViewTitleTextField.text!)
            self.headerViewTitleLabel.text = self.topBar.getTitleText()
            self.headerViewTitleTextField.alpha = 0
            self.headerViewTitleLabel.alpha = 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(todoCount)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        cell.title.text = "\(indexPath.row)"
        
        // Configure the cell...
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isTitleHided && tableView.contentOffset.y > 100 {
            isTitleHided = true
            hideHeaderTitle()
            self.topBar.showTitleLabel()
        }
        if isTitleHided && tableView.contentOffset.y <= 100 {
            isTitleHided = false
            showHeaderTitle()
            self.topBar.hideTitleLabel()
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: nil, afterDelay: 0.2)
        
        if !isBgChanged && tableView.contentOffset.y > 152 {
            isBgChanged = true
            self.tableView.backgroundColor = UIColor.groupTableViewBackground
        }
        if isBgChanged && tableView.contentOffset.y <= 152 {
            isBgChanged = false
            self.tableView.backgroundColor = UIColor.clear
        }
        groundView.updateAlpha(tableView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.bottomBar.setAddTextFieldEnable(false)
        
        if !decelerate && tableView.contentOffset.y < 76 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.tableView.contentOffset.y = 0
            }) { (_) in
            }
        }
        if !decelerate && tableView.contentOffset.y >= 76 && tableView.contentOffset.y < 152 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.tableView.contentOffset.y = 152
            }) { (_) in
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= 76 && tableView.contentOffset.y < 152 {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentOffset.y = 152
            }) { (_) in
            }
        }
        if tableView.contentOffset.y < 76 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.tableView.contentOffset.y = 0
            }) { (_) in
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.bottomBar.setAddTextFieldEnable(true)
    }
    
}
