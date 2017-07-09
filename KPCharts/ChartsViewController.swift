//
//  ChartsViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 6/15/17.
//  Copyright © 2017 Michael Merani. All rights reserved.
//

import UIKit

class ChartsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var lblRight: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var items = [""]
    var chartType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if chartType == "Punts" {
            lblLeft.text = "Distance"
            lblRight.text = "Hangtime"
        } else if chartType == "Kicks" {
            lblLeft.text = "Distance"
            lblRight.text = ""
        } else {
            lblLeft.text = "Distance"
            lblRight.text = "Hangtime"
        }
        
        //tableView.register(ChartsTableViewCell.self, forCellReuseIdentifier: "FirstCell")
        //tableView.register(ChartsTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
       // self.view.backgroundColor = .white
        
    }
    
   //MARK: Actions
    
    @IBAction func tappedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedInsert(_ sender: Any) {
        items.append("")
        let insertionIndexPath = NSIndexPath(row: items.count - 1, section: 0)
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
        tableView.reloadData()
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(indexPath.row == 0){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath as IndexPath) as! ChartsTableViewCell
//            return cell
//
//        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! ChartsTableViewCell
            return cell
    //    }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //if let deletionIndexPath = tableView.indexPath(for: cell){
                self.items.remove(at: index.row)
                tableView.deleteRows(at: [index], with: .automatic)
            //}
        }
        delete.backgroundColor = UIColor.red

        let video = UITableViewRowAction(style: .normal, title: "Video") { action, index in
           print("Video tapped")
        }
        video.backgroundColor = UIColor.lightGray
        
        return [delete,video]
    }
}
