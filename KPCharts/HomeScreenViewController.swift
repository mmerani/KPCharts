//
//  HomeScreenViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 4/11/17.
//  Copyright © 2017 Michael Merani. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    var viewChartType = UIPickerView()
    var toolBar = UIToolbar()
    var viewForPicker = UIView()
    var selectedWeek: Int?
    let pickerNames = ["Punts","Kicks","Kickoffs"]
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(selectedSignOut))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self.revealViewController(), action: #selector(revealToggle:))
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        myTableView.separatorStyle = .singleLine
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        myTableView.backgroundColor = UIColor.white
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadChartData), for: .valueChanged)
        myTableView.refreshControl = refreshControl
        if UserDefaults.standard.bool(forKey: "isLoggedIn"){
            loadChartData()
        }
        
    }
    
    func loadChartData(){
         let uid = UserDefaults.standard.object(forKey: "uid") as! String
        DataService.ds.findUserCharts(uid: uid) { (snapshot, error) in
            if snapshot.childrenCount > 0 {
                for charts in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    print("Print: \(charts)")
                }
            } else {
                print("No chart data")
            }
            self.myTableView.refreshControl?.endRefreshing()
            self.myTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
    
        return cell
    }
    // MARK: - Picker view data source

    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerNames.count
    
    }
    
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectedWeek = row
    }

}
