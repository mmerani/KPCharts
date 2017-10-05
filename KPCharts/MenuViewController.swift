//
//  MenuViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 7/23/17.
//
//

import UIKit

class MenuViewController: UITableViewController {
    
    var menuNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
      
        menuNames = ["Logout"]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as UITableViewCell

        cell.textLabel?.text = menuNames[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.set("",forKey: "uid")
            UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let loginView = storyboard.instantiateViewController(withIdentifier: "loginView")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.makeKeyAndVisible()
            appDelegate.window?.rootViewController?.present(loginView, animated: true, completion: nil)
        }
    }
}
