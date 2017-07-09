//
//  HomeScreenViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 4/11/17.
//  Copyright © 2017 Michael Merani. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var viewChartType = UIPickerView()
    var toolBar = UIToolbar()
    var viewForPicker = UIView()
    var selectedWeek: Int?
    let pickerNames = ["Punts","Kicks","Kickoffs"]
    @IBOutlet weak var myTableView: UITableView!
    
   override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
        createPicker()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(selectedSignOut))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectChartType))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconChart"), style: .plain, target: self, action: #selector(selectedChartType))
        navigationController?.navigationBar.tintColor = UIColor.white
        
        myTableView.separatorStyle = .singleLine
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        myTableView.backgroundColor = UIColor.white
    }
    func createPicker() {
        // self.typePickerView.isHidden = true
        viewForPicker.frame = CGRect(x: 0, y: self.view.frame.height/2, width: UIScreen.main.bounds.size.width, height: self.view.frame.height/2)
        self.viewChartType.dataSource = self
        self.viewChartType.delegate = self
        self.viewChartType.showsSelectionIndicator = true
        self.viewChartType.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.size.width, height: self.view.frame.height/2 - 50)
        self.viewChartType.backgroundColor = UIColor.white
        self.toolBar.frame = CGRect(x: 0, y: 0, width: self.viewForPicker.frame.width, height: 50)
        //self.toolBar.barStyle = .default
        self.toolBar.isTranslucent = false
        self.toolBar.tintColor = UIColor.white
        self.toolBar.barTintColor = UIColor(red: 60/255, green: 174/255, blue: 85/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action:#selector(doneSelected))
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action:#selector(cancelSelected))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flex2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let title = UIBarButtonItem(title: "Chart Type", style: .plain, target: nil, action: nil)
        self.toolBar.setItems([cancelButton,flex2,title,flex,doneButton], animated: false)
        self.toolBar.isUserInteractionEnabled = true
    }
    
    func selectedSignOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let loginView = storyboard.instantiateViewController(withIdentifier: "loginView")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.makeKeyAndVisible()
        appDelegate.window?.rootViewController?.present(loginView, animated: true, completion: nil)
    }
    
    func selectedChartType() {
        print("Tapped")
       // self.typePickerView.isHidden = false
        self.viewForPicker.addSubview(self.toolBar)
        self.viewForPicker.addSubview(self.viewChartType)
        self.view.addSubview(viewForPicker)
    }
    func doneSelected(sender:UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let chartsVC = storyBoard.instantiateViewController(withIdentifier: "chartsVC") as! ChartsViewController
        if selectedWeek == 0{
            chartsVC.chartType = "Punts"
        } else if selectedWeek == 1 {
            chartsVC.chartType = "Kicks"
        } else {
            chartsVC.chartType = "Kickoffs"
        }
        self.present(chartsVC, animated:true, completion:nil)
        self.viewChartType.removeFromSuperview()
        self.toolBar.removeFromSuperview()
        self.viewForPicker.removeFromSuperview()
        
    }
    
    func cancelSelected(){
        self.viewChartType.removeFromSuperview()
        self.toolBar.removeFromSuperview()
        self.viewForPicker.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
