//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/4/22.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

private let kTopViewHeight: CGFloat = 500

class ToDoTableViewController: UITableViewController {
    private var headerView: UIView!
    private var bottomView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
                bottomView = UIView(frame: self.view.frame)
        bottomView.backgroundColor = UIColor(red: 60/255, green: 160/255, blue: 183/255, alpha: 1)
//        self.view.addSubview(bottomView)
//        self.view.sendSubview(toBack: bottomView)
        
//        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
//        self.tableView.register(nib, forCellReuseIdentifier: "todoCell")
        tableView.rowHeight = 48.0
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNavigationBar), name: .UIApplicationDidBecomeActive, object: nil)
        
        
    }
    
    func setNavigationBar(){
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 64)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationBar()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)

        // Configure the cell...

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 152))
//        headerView.backgroundColor = UIColor(red: 60/255, green: 160/255, blue: 183/255, alpha: 1)
//
//        return headerView
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 152
//    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 300))
//        footerView.backgroundColor = UIColor.gray
//        return footerView
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 300
//    }
    
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "aavb"
//    }

    @IBAction func buttonTapped(_ sender: Any) {
        print(tableView.contentInset.top)
        print(tableView.contentOffset.y)
    }
    

}
