//
//  SavedChartsController.swift
//  KPCharts
//
//  Created by Michael Merani on 8/5/17.
//
//

import UIKit
import Firebase


class SavedChartsController: UITableViewController {

    var chartList = [FIRDataSnapshot]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadChartData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        loadChartData()

    }

    func loadChartData(){
        if let uid = UserDefaults.standard.object(forKey: "uid") {
            DataService.ds.findUserCharts(uid: uid as! String) { (snapshot, error) in
                if snapshot.childrenCount > 0 {
                    self.chartList = snapshot.children.allObjects as! [FIRDataSnapshot]
                    
                } else {
                    print("No chart data")
                }
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedChartsCell", for: indexPath) as! SavedChartsCell

        let data = chartList[indexPath.row]

        cell.lblChartTitle.text =  data.childSnapshot(forPath: "title").value as? String
        cell.lblChartType.text = data.childSnapshot(forPath: "chartType").value as? String

        let checkType = data.childSnapshot(forPath: "chartType").value as? String
        if checkType == "Kicks"{
            cell.lblDataTitle.text = "FGs Made"
            cell.lblData.text = data.childSnapshot(forPath: "completion").value as? String
        } else {
            cell.lblDataTitle.text = "Avg Distance"
            cell.lblData.text = "\(data.childSnapshot(forPath: "avgDistance").value ?? 0)"
        }
        

        return cell
    }
 
}
