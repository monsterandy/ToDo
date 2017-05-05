//
//  ToDoViewController.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/29.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BottomBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var groundView: GroundView!
    var topBar: TopBar!
    var bottomBar: BottomBar!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewTitleLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    private var isBgChanged = false
    private var isTitleHided = false
    private var isEditViewMovedUp = false
    private var todoCount:CGFloat = 11
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNavigationBar), name: .UIApplicationDidBecomeActive, object: nil)
        headerView.backgroundColor = UIColor.clear
        groundView = GroundView(frame: view.frame)
        self.view.insertSubview(groundView, belowSubview: tableView)
        bottomBar = BottomBar(frame: CGRect(x: 0, y: self.view.frame.height-57, width: self.view.frame.width, height: 57))
        self.view.addSubview(bottomBar)
        bottomBar.delegate = self
        print(view.frame.width)
        
    }
    
    func setNavigationBar() {
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 64)
    }
    
    func hideHeaderTitle() {
        UIView.animate(withDuration: 0.15) {
            self.headerViewTitleLabel.alpha = 0
        }
    }
    
    func showHeaderTitle() {
        UIView.animate(withDuration: 0.2) {
            self.headerViewTitleLabel.alpha = 1
        }
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
    
    
    // MARK - Bottom Bar Delegate
    func bottomBarDidMovedUp(bottomBar: BottomBar, deltaY: CGFloat) {
        let contentSize: CGFloat
        if isTitleHided {
            contentSize = todoCount * self.tableView.rowHeight + 84
        } else {
            contentSize = todoCount * self.tableView.rowHeight + 152 + 84
        }
//        if !isEditViewMovedUp {
            self.moveScale = contentSize - (self.view.bounds.height - 289.5 - 101.5)
//        }
        if !isTitleHided && moveScale < 152 {
            self.moveScale = 152.0
        }
        if !isEditViewMovedUp && moveScale > 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentOffset.y += self.moveScale
            })
            self.tableView.isUserInteractionEnabled = false
//            self.bottomBar.addEditMaskView(self.bottomBar.frame.origin)
//            print(self.bottomBar.frame.origin)
            
        }
        self.isEditViewMovedUp = true
    }
    
    func bottomBarDidMovedDown(bottomBar: BottomBar) {
        print(moveScale)
        if isEditViewMovedUp && moveScale > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentOffset.y -= self.moveScale
            })
            self.tableView.isUserInteractionEnabled = true
        }
        self.isEditViewMovedUp = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        self.bottomBar.cancelEdit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationBar()
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
//        if tableView.contentOffset.y < 76 {
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                self.tableView.contentOffset.y = 0
//            }) { (_) in
//            }
//        }
    }
    
    
}
