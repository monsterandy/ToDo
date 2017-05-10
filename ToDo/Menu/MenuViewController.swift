//
//  MenuViewController.swift
//  ToDo
//
//  Created by 麻哲源 on 2017/5/8.
//  Copyright © 2017年 Andy. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var menuTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        self.menuTableView.register(nib, forCellReuseIdentifier: "menuItemCell")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.menuTableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath) as! MenuTableViewCell
        cell.menuItemTitle.text = "Menu Item " + "\(indexPath.row)"
        return cell
    }
    
    

}
