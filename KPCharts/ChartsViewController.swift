//
//  ChartsViewController.swift
//  KPCharts
//
//  Created by Michael Merani on 6/15/17.
//  Copyright © 2017 Michael Merani. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation


class ChartsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var lblRight: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblAverages: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var avgDistance = 0.0
    var avgHangtime = 0.0
    var madeFgs = 0
    var totalFgs = 0
    
    var items = [""]
    var dataSet = [Dictionary<String, Any>]()
    var dataDict = [String: Any]()
    var chartType: String?
    var chartTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chartTitle != "" {
            lblTitle.text = chartTitle
        } else {
            lblTitle.text = chartType
        }
       
        if chartType == "Punts" || chartType == "Kickoffs" {
            lblLeft.text = "Distance"
            lblRight.text = "Hangtime"
            lblAverages.text = "Avg Distance: 0.0"
        } else if chartType == "Kicks" {
            lblLeft.text = "Distance"
            lblRight.text = ""
            lblAverages.text = "Made: 0/0"
        }
        btnClose.setImage(UIImage(named: "arrowDown")?.tintWithColor(color: UIColor.white), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
   //MARK: Actions
    
    @IBAction func tappedClose(_ sender: Any) {
        let alert = UIAlertController(title:"Are you sure?", message: "Chart will not be saved if you close", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedAdd(_ sender: Any) {
        items.append("")
        let insertionIndexPath = NSIndexPath(row: items.count - 1, section: 0)
        calculateAverages()
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
        tableView.reloadData()

    }
    func calculateAverages(){
        let cells = tableView.visibleCells
        
        self.avgDistance = 0.0
        self.avgHangtime = 0.0
        self.madeFgs = 0
        self.totalFgs = 0
        if chartType == "Punts" || chartType == "Kickoffs" {
            var nonZeroYardsCounter = 0
            var nonZeroHangCounter = 0
            for cell in cells {
                let customCell = cell as! ChartsTableViewCell
                if let yards = Double(customCell.txtFieldYards.text!) {
                    if yards > 0 {
                        self.avgDistance += yards
                        nonZeroYardsCounter += 1
                    }
                }
                if let hangtime = Double(customCell.txtFieldHangtime.text!){
                    if hangtime > 0 {
                        self.avgHangtime += hangtime
                        nonZeroHangCounter += 1
                    }
                }
            }
            self.avgDistance = self.avgDistance/Double(nonZeroYardsCounter)
            self.avgHangtime = self.avgHangtime/Double(nonZeroHangCounter)
            lblAverages.text = "Avg Distance:\(round(100*self.avgDistance)/100) Time:\(round(100*self.avgHangtime)/100)"
        } else {
            for cell in cells {
                let customCell = cell as! ChartsTableViewCell
                let completion = customCell.makeOrMiss.selectedSegmentIndex
                totalFgs += 1
                if completion == 0 {
                    madeFgs += 1
                }
            }
            lblAverages.text = "Made: \(madeFgs)/\(totalFgs)"
        }
    }
    
    @IBAction func tappedSave(_ sender: Any) {
        let cells = tableView.visibleCells
        
        let uid = UserDefaults.standard.object(forKey: "uid") as! String
        
        var data = Dictionary<String, Any>()
        
        if chartType == "Punts" || chartType == "Kickoffs" {
            for cell in cells {
                let customCell = cell as! ChartsTableViewCell
                if customCell.txtFieldYards.text != "0" || customCell.txtFieldHangtime.text != "0"{
                    let yards = Double(customCell.txtFieldYards.text!)
                    let hangtime = Double(customCell.txtFieldHangtime.text!)
                    dataDict["yards"] = yards
                    dataDict["time"] = hangtime
                    dataSet.append(dataDict)
                }
                 data = ["uid": uid,
                            "chartType": self.chartType!,
                            "chartData": dataSet as Array,
                            "avgDistance": self.avgDistance,
                            "avgHang": self.avgHangtime,
                            "title": self.chartTitle ?? self.chartType!] as [String : Any]

            }
        } else {
            for cell in cells {
                let customCell = cell as! ChartsTableViewCell
                let attemptResult = customCell.makeOrMiss.selectedSegmentIndex
                let yards = customCell.txtFieldKickYards.text
                dataDict["yards"] = yards
                dataDict["attemptResult"] = attemptResult
                dataSet.append(dataDict)
            }
             data = ["uid": uid,
                        "chartType": self.chartType!,
                        "chartData": dataSet as Array,
                        "completion": "\(madeFgs)/\(totalFgs)",
                        "title": self.chartTitle ?? self.chartType!] as [String : Any]

        }
        DataService.ds.setChartData(chartData: data, completion: { (success, error) in
            if success {
                let alert = UIAlertController(title:nil, message: "Your charting has been saved!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAction)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChartData"), object: nil)
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Data not saved")
            }
        })
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
        
        if chartType == "Punts" || chartType == "Kickoffs" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! ChartsTableViewCell
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KickCell", for: indexPath as IndexPath) as! ChartsTableViewCell
            return cell
       }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //if let deletionIndexPath = tableView.indexPath(for: cell){
            self.items.remove(at: index.row)
            tableView.deleteRows(at: [index], with: .automatic)
            self.calculateAverages()
            //}
        }
        delete.backgroundColor = UIColor.red

        let video = UITableViewRowAction(style: .normal, title: "Video") { action, index in
           print("Video tapped")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let setupChart = storyBoard.instantiateViewController(withIdentifier: "videoVC") as! VideoViewController
            self.present(setupChart, animated:false, completion:nil)

            
        }
        video.backgroundColor = UIColor.lightGray
        
        return [delete,video]
    }
}
